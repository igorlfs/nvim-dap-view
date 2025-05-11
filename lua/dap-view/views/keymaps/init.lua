local state = require("dap-view.state")
local threads_view = require("dap-view.threads.view")
local watches_view = require("dap-view.watches.view")
local watches_actions = require("dap-view.watches.actions")
local docs = require("dap-view.views.keymaps.docs")
local keymap = require("dap-view.views.keymaps.util").keymap

local M = {}

M.set_keymaps = function()
    keymap("<CR>", function()
        if state.current_section == "breakpoints" then
            require("dap-view.views.util").jump_to_location("^(.-)|(%d+)|")
        elseif state.current_section == "threads" then
            require("dap-view.threads.actions").jump_or_noop()
        elseif state.current_section == "exceptions" then
            require("dap-view.exceptions.actions").toggle_exception_filter()
        elseif state.current_section == "scopes" then
            require("dap.ui").trigger_actions({ mode = "first" })
        elseif state.current_section == "watches" then
            local cursor_line = vim.api.nvim_win_get_cursor(state.winnr)[1]
            watches_actions.expand_or_collapse(cursor_line)
        end
    end)

    keymap("o", function()
        if state.current_section == "scopes" then
            require("dap.ui").trigger_actions()
        end
    end)

    keymap("i", function()
        if state.current_section == "watches" then
            vim.ui.input({ prompt = "Expression: " }, function(input)
                if input then
                    watches_actions.add_watch_expr(input)
                end
            end)
        end
    end)

    keymap("d", function()
        if state.current_section == "watches" then
            local cursor_line = vim.api.nvim_win_get_cursor(state.winnr)[1]

            watches_actions.remove_watch_expr(cursor_line)

            watches_view.show()
        end
    end)

    keymap("e", function()
        if state.current_section == "watches" then
            local cursor_line = vim.api.nvim_win_get_cursor(state.winnr)[1]

            local expression = state.expressions_by_line[cursor_line]
            if expression then
                vim.ui.input({ prompt = "Expression: ", default = expression.name }, function(input)
                    if input then
                        watches_actions.edit_watch_expr(input, cursor_line)
                    end
                end)
            end
        end
    end)

    keymap("c", function()
        if state.current_section == "watches" then
            local cursor_line = vim.api.nvim_win_get_cursor(state.winnr)[1]

            watches_actions.copy_watch_expr(cursor_line)
        end
    end)

    keymap("s", function()
        if state.current_section == "watches" then
            local cursor_line = vim.api.nvim_win_get_cursor(state.winnr)[1]

            local get_default = function()
                local expr = state.expressions_by_line[cursor_line]
                if expr and expr.expression and type(expr.expression.response) ~= "string" then
                    return expr.expression.response.result
                end

                local var = state.variables_by_line[cursor_line]
                if var then
                    return var.response.value
                end

                return ""
            end

            vim.ui.input({ prompt = "New value: ", default = get_default() }, function(input)
                if input then
                    watches_actions.set_watch_expr(input, cursor_line)
                end
            end)
        end
    end)

    keymap("t", function()
        if state.current_section == "threads" then
            state.subtle_frames = not state.subtle_frames

            threads_view.show()
        end
    end)

    keymap("g?", function()
        docs.show_help()
    end)
end

return M
