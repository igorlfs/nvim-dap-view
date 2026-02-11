local state = require("dap-view.state")
local watches_actions = require("dap-view.watches.actions")
local setup = require("dap-view.setup")
local keymap = require("dap-view.views.keymaps.util").keymap
local switchbuf = require("dap-view.views.windows.switchbuf")

local M = {}

local api = vim.api

M.views_keymaps = function()
    keymap({ "<CR>", "<2-LeftMouse>" }, function()
        local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

        if state.current_section == "breakpoints" then
            require("dap-view.breakpoints.actions").jump(cursor_line)
        elseif state.current_section == "threads" then
            require("dap-view.threads.actions").jump_and_set_frame(cursor_line)
        elseif state.current_section == "sessions" then
            require("dap-view.sessions.actions").switch_to_session(cursor_line)
        elseif state.current_section == "exceptions" then
            require("dap-view.exceptions.actions").toggle_exception_filter()
        elseif state.current_section == "watches" then
            coroutine.wrap(function()
                if watches_actions.expand_or_collapse(cursor_line) then
                    require("dap-view.views").switch_to_view("watches")
                end
            end)()
        elseif state.current_section == "scopes" then
            coroutine.wrap(function()
                if require("dap-view.scopes.actions").expand_or_collapse(cursor_line) then
                    require("dap-view.views").switch_to_view("scopes", true)
                end
            end)()
        end
    end)

    keymap("<C-w><CR>", function()
        if state.current_section == "breakpoints" or state.current_section == "threads" then
            local options = vim.iter(switchbuf.switchbuf_winfn):fold({}, function(acc, k, v)
                acc[#acc + 1] = { label = k, cb = v }
                return acc
            end)

            if type(setup.config.switchbuf) == "function" then
                options[#options + 1] = { label = "custom", cb = setup.config.switchbuf }
            end

            local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

            vim.ui.select(
                options,
                {
                    prompt = "Specify jump behavior: ",
                    ---@param item {label: string}
                    format_item = function(item)
                        return item.label
                    end,
                },
                ---@param choice {label: string, cb: dapview.SwitchBufFun}?
                function(choice)
                    if choice ~= nil then
                        if state.current_section == "breakpoints" then
                            require("dap-view.views.util").jump(cursor_line, choice.cb)
                        elseif state.current_section == "threads" then
                            require("dap-view.threads.actions").jump_and_set_frame(cursor_line, choice.cb)
                        end
                    end
                end
            )
        end
    end)

    keymap("o", function()
        if state.current_section == "threads" then
            state.threads_filter_invert = not state.threads_filter_invert

            require("dap-view.views").switch_to_view("threads")
        end
    end)

    keymap("a", function()
        if state.current_section == "watches" then
            require("dap-view.watches.keymaps").new_expression(true)
        end
    end)

    keymap("i", function()
        if state.current_section == "watches" then
            require("dap-view.watches.keymaps").new_expression(false)
        end
    end)

    keymap("d", function()
        local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]
        if state.current_section == "watches" then
            watches_actions.remove_watch_expr(cursor_line)

            require("dap-view.views").switch_to_view("watches")
        elseif state.current_section == "breakpoints" then
            require("dap-view.breakpoints.actions").remove(cursor_line)

            -- If a session is active, `setBreakpoints` will trigger anyway
            -- It's best avoid a redraw here
            if require("dap").session() == nil then
                require("dap-view.views").switch_to_view("breakpoints")
            end
        end
    end)

    keymap("e", function()
        if state.current_section == "watches" then
            local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

            local expression_view = state.expression_views_by_line[cursor_line]
            if expression_view then
                vim.ui.input({ prompt = "Expression: ", default = expression_view.expression }, function(input)
                    if input then
                        coroutine.wrap(function()
                            if watches_actions.edit_watch_expr(input, cursor_line) then
                                require("dap-view.views").switch_to_view("watches")
                            end
                        end)()
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
        local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

        -- Can only set value if stopped
        if not require("dap-view.guard").expect_stopped() then
            return
        end

        if state.current_section == "scopes" then
            local variable_path = state.line_to_variable_path[cursor_line]

            if variable_path then
                local variable_value = state.variable_path_to_value[variable_path]
                local parent_reference = state.variable_path_to_parent_reference[variable_path]
                local variable_name = state.variable_path_to_name[variable_path]
                local evaluate_name = state.variable_path_to_evaluate_name[variable_path]

                vim.ui.input({ prompt = "New value: ", default = variable_value }, function(value)
                    if value then
                        require("dap-view.views.set").set_value(parent_reference, variable_name, value, evaluate_name)

                        coroutine.wrap(function()
                            require("dap-view.views").switch_to_view("scopes")
                        end)()
                    end
                end)
            end
        elseif state.current_section == "watches" then
            local get_default = function()
                local expression_view = state.expression_views_by_line[cursor_line]
                if expression_view and expression_view.view and expression_view.view.response then
                    return expression_view.view.response.result
                end

                local variable_reference = state.variable_views_by_line[cursor_line]
                if variable_reference then
                    return variable_reference.view.variable.value
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
