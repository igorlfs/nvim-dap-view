local state = require("dap-view.state")
local watches_view = require("dap-view.watches.view")
local watches_actions = require("dap-view.watches.actions")

local M = {}

M.set_options = function()
    local win = vim.wo[state.winnr][0]
    win.scrolloff = 0
    win.wrap = false
    win.number = false
    win.relativenumber = false
    win.winfixheight = true
    win.cursorlineopt = "line"
    win.cursorline = true
    win.statuscolumn = ""
    win.foldcolumn = "0"

    local buf = vim.bo[state.bufnr]
    buf.buftype = "nofile"
    buf.swapfile = false
    buf.filetype = "dap-view"
end

M.set_keymaps = function()
    vim.keymap.set("n", "<CR>", function()
        if state.current_section == "breakpoints" then
            require("dap-view.breakpoints.actions")._jump_to_breakpoint()
        elseif state.current_section == "exceptions" then
            require("dap-view.exceptions.actions")._toggle_exception_filter()
        end
    end, { buffer = state.bufnr })

    vim.keymap.set("n", "i", function()
        if state.current_section == "watches" then
            vim.ui.input({ prompt = "Expression: " }, function(input)
                if input then
                    watches_actions.add_watch_expr(input)
                end
            end)
        end
    end, { buffer = state.bufnr })

    vim.keymap.set("n", "d", function()
        if state.current_section == "watches" then
            local line = vim.api.nvim_win_get_cursor(state.winnr)[1]

            watches_actions.remove_watch_expr(line)

            watches_view.show()
        end
    end, { buffer = state.bufnr })

    vim.keymap.set("n", "e", function()
        if state.current_section == "watches" then
            local line = vim.api.nvim_win_get_cursor(state.winnr)[1]

            local current_expr = state.watched_expressions[line]

            vim.ui.input({ prompt = "Expression: ", default = current_expr }, function(input)
                if input and watches_actions.is_expr_valid(input) then
                    watches_actions.edit_watch_expr(input, line)
                end
            end)
        end
    end, { buffer = state.bufnr })
end

return M
