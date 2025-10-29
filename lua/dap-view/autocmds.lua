local dap = require("dap")

local util = require("dap-view.util")
local window = require("dap-view.util.window")
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
        local session = dap.session()
        local adapter = session and session.config.type

        local follow_tab = setup.config.follow_tab
        local follow_tab_ = (type(follow_tab) == "function" and follow_tab(adapter))
            or (type(follow_tab) == "boolean" and follow_tab)

        local open_winnr = window.fetch_window()

        -- When follow_tab is a function, we have to "restore" what otherwise would be a leftover window
        --
        -- Consider the following scenario:
        -- - Tab 1 is active and has a dap-view window
        -- - User switches to tab 2, which is not eligible by `follow_tab`
        -- - `state.winnr` is now set to `nil`, but the window still exists on tab 1 (intended)
        -- - User switches to tab 3, which is eligible by `follow_tab`
        -- - Since there's a dap-view window elsewhere, we have to "reopen" to "follow the tab"
        -- (otherwise, visiting a non eligible tab wouldn't make much sense - afterwards, we'd keep the "closed" state)
        -- - We can do that just fine, since now we track the correct window with a (window) variable
        -- - Buf if the user closes the newly opened dap-view window on tab 3, and switches back to tab 1
        -- The original window will still be there! Since we closed, we don't want that!
        --
        -- This happens because the "close" function does not close all the the valid windows, only the one tracked by
        -- `state.winnr`, which is `nil` by then (massive oversight, I know)
        --
        -- This never came up before the dynamic `follow_tab` because we could always assume `state.winnr` was either
        -- from the current tab or the previous tab (which would then be handle by this very own autocmd)
        --
        -- By assigning `state.winnr` to the open window (which may be anywhere), `open`'s call to `close` will clean it
        if open_winnr and state.winnr == nil then
            state.winnr = open_winnr
        end

        if util.is_win_valid(state.winnr) and follow_tab_ then
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
