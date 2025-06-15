local state = require("dap-view.state")
local globals = require("dap-view.globals")
local winbar = require("dap-view.options.winbar")

local api = vim.api

api.nvim_create_autocmd("TabEnter", {
    callback = function()
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
        end

        state.winnr = winnr
        state.term_winnr = term_winnr

        if winnr ~= nil then
            winbar.show_content(state.current_section)
        end
    end,
})

api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        local buf = args.buf
        if not api.nvim_buf_is_valid(buf) then
            return
        end
        local win = api.nvim_get_current_win()
        local ft = vim.bo[buf].filetype

        -- Reset the winnr if the buffer changed
        --
        -- We can't use winfixbuf since the window shares many buffers (REPL, Console)
        --
        -- Therefore, it's possible to switch to a (regular) buffer (any ft) while keeping the status of state.winnr
        --
        -- While it's unlikely users do that very often, such change occurs when the switchbuf is triggerd as "newtab"
        -- For some reason, the new tab starts with the "dap-view" ft, which causes the winbar to appear on the regular buffer
        if state.winnr == win then
            if not vim.tbl_contains({ "dap-view", "dap-view-term", "dap-repl" }, ft) then
                state.winnr = nil
            end
        elseif not state.winnr then
            if
                vim.tbl_contains({ "dap-view", "dap-repl" }, ft)
                or (ft == "dap-view-term" and state.current_section == "console")
            then
                state.winnr = win
            end
        end

        -- For good measure, also handle term_winnr
        if state.term_winnr == win and ft ~= "dap-view-term" then
            state.term_winnr = nil
        end
    end,
})

api.nvim_create_autocmd("CursorMoved", {
    pattern = globals.MAIN_BUF_NAME,
    callback = function()
        state.cur_pos[state.current_section] = api.nvim_win_get_cursor(state.winnr)[1]
    end,
})
