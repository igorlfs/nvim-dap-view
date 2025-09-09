local util = require("dap-view.util")
local state = require("dap-view.state")
local setup = require("dap-view.setup")
local globals = require("dap-view.globals")
local winbar = require("dap-view.options.winbar")

local api = vim.api

api.nvim_create_autocmd({ "WinClosed", "WinNew" }, {
    callback = function()
        vim.schedule(function()
            if state.winnr ~= nil then
                winbar.refresh_winbar()
            end
        end)
    end,
})

api.nvim_create_autocmd("TabEnter", {
    callback = function()
        if util.is_win_valid(state.winnr) and setup.config.follow_tab then
            require("dap-view.actions").open(state.term_winnr ~= nil)
        end

        -- Defer execution to ensure that the filetype doesn't match the one that created the tab
        --
        -- Otherwise the new window may get assigned as the `state.winnr` (if the tab was created from
        -- nvim-dap-view's window, which is possible when `switchbuf` contains "newtab")
        --
        -- This can also happen if regular nvim-dap's switchbuf contains "newtab"
        --
        -- When a new tab is created, for a brief moment the new window inherits the filetype of the window
        -- that the user was on when `tabnew` was called
        --
        -- When a random window gets assigned as `state.winnr` all sorts of crazy stuff may happen.
        -- However, most notably, the window will inherit nvim-dap-view's winbar
        vim.schedule(function()
            local winnr = nil
            local term_winnr = nil

            for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
                local bufnr = api.nvim_win_get_buf(win)
                local ft = vim.bo[bufnr].filetype

                if ft == "dap-view" then
                    if winnr == nil then
                        winnr = win
                    end
                end

                if ft == "dap-view-term" then
                    if state.current_section == "console" then
                        if winnr == nil then
                            winnr = win
                        end
                    elseif term_winnr == nil then
                        term_winnr = win
                    end
                end

                if ft == "dap-repl" and state.current_section == "repl" then
                    if winnr == nil then
                        winnr = win
                    end
                end

                for custom_section_id, custom_section in pairs(setup.config.winbar.custom_sections) do
                    if
                        ft == custom_section.filetype
                        and state.current_section == custom_section_id
                        and state.winnr == nil
                    then
                        winnr = win
                    end
                end
            end

            state.winnr = winnr
            -- Track the state of the last term win, so it can be closed later if becomes a leftover window
            if state.term_winnr and term_winnr ~= state.term_winnr then
                state.last_term_winnr = state.term_winnr
            end
            state.term_winnr = term_winnr

            if winnr ~= nil then
                winbar.show_content(state.current_section)
            end
        end)
    end,
})

api.nvim_create_autocmd("CursorMoved", {
    pattern = globals.MAIN_BUF_NAME,
    callback = function()
        -- The window may be invalid when switching tabs, given that now we defer the update when switching tabs
        if util.is_win_valid(state.winnr) then
            state.cur_pos[state.current_section] = api.nvim_win_get_cursor(state.winnr)[1]
        end
    end,
})
