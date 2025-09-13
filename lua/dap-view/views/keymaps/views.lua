local state = require("dap-view.state")
local watches_actions = require("dap-view.watches.actions")
local keymap = require("dap-view.views.keymaps.util").keymap

local M = {}

local api = vim.api

M.views_keysmps = function()
    keymap("<CR>", function()
        local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

        if state.current_section == "breakpoints" then
            require("dap-view.views.util").jump_to_location("^(.-)|(%d+)|")
        elseif state.current_section == "threads" then
            require("dap-view.threads.actions").jump_or_noop(cursor_line)
        elseif state.current_section == "exceptions" then
            require("dap-view.exceptions.actions").toggle_exception_filter()
        elseif state.current_section == "scopes" or state.current_section == "sessions" then
            require("dap.ui").trigger_actions({ mode = "first" })
        elseif state.current_section == "watches" then
            watches_actions.expand_or_collapse(cursor_line)
        end

        -- Selecting a session triggers a full redraw
        -- To properly restore the cursor position we have to call switch_to_view
        if state.current_section == "sessions" then
            require("dap-view.views").switch_to_view("sessions")
        end
    end)

    keymap("o", function()
        if state.current_section == "scopes" then
            require("dap.ui").trigger_actions()
        elseif state.current_section == "threads" then
            state.threads_filter_invert = not state.threads_filter_invert

            require("dap-view.views").switch_to_view("threads")
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
            local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

            watches_actions.remove_watch_expr(cursor_line)

            require("dap-view.views").switch_to_view("watches")
        elseif state.current_section == "breakpoints" then
            require("dap-view.breakpoints.actions").remove_breakpoint()

            require("dap-view.breakpoints.view").show()
        end
    end)

    keymap("e", function()
        if state.current_section == "watches" then
            local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

            local expression_view = state.expression_views_by_line[cursor_line]
            if expression_view then
                vim.ui.input({ prompt = "Expression: ", default = expression_view.expression }, function(input)
                    if input then
                        watches_actions.edit_watch_expr(input, cursor_line)
                    end
                end)
            end
        end
    end)

    keymap("f", function()
        if state.current_section == "threads" then
            vim.ui.input({ prompt = "Filter: ", default = state.threads_filter }, function(input)
                if input then
                    state.threads_filter = input

                    require("dap-view.views").switch_to_view("threads")
                end
            end)
        end
    end)

    keymap("c", function()
        if state.current_section == "watches" then
            local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

            watches_actions.copy_watch_expr(cursor_line)
        end
    end)

    keymap("s", function()
        if state.current_section == "scopes" then
            require("dap.ui").trigger_actions({ filter = "Set expression" })
        elseif state.current_section == "watches" then
            local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

            local get_default = function()
                local expression_view = state.expression_views_by_line[cursor_line]
                if expression_view and expression_view.view and expression_view.view.response then
                    return expression_view.view.response.result
                end

                local variable_reference = state.variable_views_by_line[cursor_line]
                if variable_reference then
                    return variable_reference.variable.value
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

            require("dap-view.views").switch_to_view("threads")
        end
    end)
end

return M
