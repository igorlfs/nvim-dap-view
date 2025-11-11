local state = require("dap-view.state")
local watches_actions = require("dap-view.watches.actions")
local setup = require("dap-view.setup")
local keymap = require("dap-view.views.keymaps.util").keymap
local switchbuf = require("dap-view.views.windows.switchbuf")

local M = {}

local api = vim.api

M.views_keymaps = function()
    keymap("<CR>", function()
        local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

        if state.current_section == "breakpoints" then
            require("dap-view.views.util").jump_to_location("^(.-)|(%d+)|")
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
                            require("dap-view.views.util").jump_to_location("^(.-)|(%d+)|", nil, choice.cb)
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

    keymap("i", function()
        if state.current_section == "watches" then
            vim.ui.input({ prompt = "Expression: " }, function(input)
                if input then
                    coroutine.wrap(function()
                        if watches_actions.add_watch_expr(input, true) then
                            require("dap-view.views").switch_to_view("watches")
                        end
                    end)()
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
        -- TODO migrate this
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
