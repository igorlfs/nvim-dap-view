local state = require("dap-view.state")

local M = {}

---@param line integer
M.toggle_exception_filter = function(line)
    ---@type dapview.ExceptionsOption
    local current_option = state.exceptions_options[state.current_adapter][line]

    current_option.enabled = not current_option.enabled

    require("dap-view.exceptions").update_exception_breakpoints_filters()
    require("dap-view.exceptions.view").show()
end

---@param line integer
M.set_conditon = function(line)
    ---@type dapview.ExceptionsOption
    local current_option = state.exceptions_options[state.current_adapter][line]

    local filter = current_option.exception_filter

    if not filter.supportsCondition then
        vim.notify("Condition not supported")
        return
    end

    -- I like short lines
    local default = ((state.exception_filter_options_by_adapter[state.current_adapter] or {})[filter.filter] or {}).condition

    vim.ui.input({ default = default, prompt = "Condition: " }, function(input)
        if input then
            state.exception_filter_options_by_adapter[state.current_adapter][filter.filter] = input ~= ""
                    and {
                        filterId = filter.filter,
                        condition = input,
                    }
                or nil

            require("dap-view.exceptions").update_exception_breakpoints_filters()
            require("dap-view.exceptions.view").show()
        end
    end)
end

---@param line integer
M.clear_conditon = function(line)
    ---@type dapview.ExceptionsOption
    local current_option = state.exceptions_options[state.current_adapter][line]

    local filter = current_option.exception_filter

    if not filter.supportsCondition then
        vim.notify("Condition not supported")
        return
    end

    state.exception_filter_options_by_adapter[state.current_adapter][filter.filter] = nil

    require("dap-view.exceptions").update_exception_breakpoints_filters()
    require("dap-view.exceptions.view").show()
end

return M
