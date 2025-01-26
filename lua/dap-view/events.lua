local dap = require("dap")

local state = require("dap-view.state")
local breakpoints = require("dap-view.breakpoints.view")
local watches = require("dap-view.watches.view")
local term = require("dap-view.term.init")
local eval = require("dap-view.watches.eval")

local SUBSCRIPTION_ID = "dap-view"

dap.listeners.before.initialize[SUBSCRIPTION_ID] = function()
    term.term_buf_win_init()
end

dap.listeners.after.setBreakpoints[SUBSCRIPTION_ID] = function()
    if state.current_section == "breakpoints" then
        breakpoints.show()
    end
end

dap.listeners.after.evaluate[SUBSCRIPTION_ID] = function()
    if state.current_section == "watches" then
        watches.show()
    end
end

dap.listeners.after.variables[SUBSCRIPTION_ID] = function()
    if state.current_section == "watches" then
        watches.show()
    end
end

dap.listeners.after.event_stopped[SUBSCRIPTION_ID] = function()
    if state.current_section == "watches" then
        for i, expr in ipairs(state.watched_expressions) do
            eval.eval_expr(expr, function(result)
                state.updated_evaluations[i] = state.expression_results[i]
                    and state.expression_results[i] ~= result
                state.expression_results[i] = result
            end)
        end
    end
end

dap.listeners.after.initialize[SUBSCRIPTION_ID] = function(session, _)
    state.exceptions_options = vim.iter(session.capabilities.exceptionBreakpointFilters)
        :map(function(filter)
            return { enabled = filter.default, exception_filter = filter }
        end)
        :totable()
end

dap.listeners.after.event_terminated[SUBSCRIPTION_ID] = function()
    for k in ipairs(state.expression_results) do
        state.expression_results[k] = nil
    end
end
