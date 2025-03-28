local state = require("dap-view.state")
local threads_view = require("dap-view.threads.view")
local watches_view = require("dap-view.watches.view")
local watches_actions = require("dap-view.watches.actions")

local M = {}

M.set_keymaps = function()
    vim.keymap.set("n", "<CR>", function()
        if state.current_section == "breakpoints" then
            require("dap-view.views.util").jump_to_location("^(.-)|(%d+)|")
        elseif state.current_section == "threads" then
            require("dap-view.threads.actions").jump_or_noop()
        elseif state.current_section == "exceptions" then
            require("dap-view.exceptions.actions").toggle_exception_filter()
        elseif state.current_section == "scopes" then
            require("dap.ui").trigger_actions({ mode = "first" })
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
    end, { buffer = state.bufnr, nowait = true })

    vim.keymap.set("n", "e", function()
        if state.current_section == "watches" then
            local line = vim.api.nvim_win_get_cursor(state.winnr)[1]

            vim.ui.input(
                { prompt = "Expression: ", default = state.watched_expressions[line] },
                function(input)
                    if input then
                        watches_actions.edit_watch_expr(input, line)
                    end
                end
            )
        end
    end, { buffer = state.bufnr })

    vim.keymap.set("n", "t", function()
        if state.current_section == "threads" then
            state.subtle_frames = not state.subtle_frames

            threads_view.show()
        end
    end, { buffer = state.bufnr })
end

return M
