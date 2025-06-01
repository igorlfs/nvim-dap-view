local state = require("dap-view.state")
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
