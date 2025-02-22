local dap = require("dap")

local state = require("dap-view.state")
local breakpoints = require("dap-view.breakpoints.view")
local watches = require("dap-view.watches.view")
local threads = require("dap-view.threads.view")
local exceptions = require("dap-view.exceptions.view")
local term = require("dap-view.term.init")
local eval = require("dap-view.watches.eval")
local setup = require("dap-view.setup")

local SUBSCRIPTION_ID = "dap-view"

dap.listeners.before.initialize[SUBSCRIPTION_ID] = function(session, _)
    local adapter = session.config.type
    -- When initializing a new session, there might a leftover terminal buffer
    -- Usually, this wouldn't be a problem, but it can cause inconsistencies when starting a session that
    --
    -- (A) Doesn't use the terminal, after a session that does
    -- The problem here is that the terminal could be used if it was left open from the earlier session
    --
    -- (B) Uses the terminal, after a session that doesn't
    -- The terminal wouldn't show up, since it's hidden
    --
    -- To handle these scenarios, we have to close the terminal buffer
    -- However, if we always close the terminal, dap-view will be shifted very quickly (if open),
    -- causing a flickering effect.
    --
    -- To address that, we only close the terminal if the new session has a different adapter
    -- (which should cover most scenarios where the flickering would occur)
    --
    -- Since there has not been a `last_active_adapter` yet, we don't need to
    -- call `delete_term_buf`, which conflicts with bootstrapping the terminal
    -- window.  See: https://github.com/igorlfs/nvim-dap-view/issues/18
    if state.last_active_adapter and state.last_active_adapter ~= adapter then
        term.delete_term_buf()
    end
    state.last_active_adapter = adapter

    term.setup_term()
    if not setup.config.windows.terminal.start_hidden then
        term.open_term_buf_win()
    end
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

dap.listeners.after.stackTrace[SUBSCRIPTION_ID] = function()
    if state.current_section == "threads" then
        threads.show()
    end
end

dap.listeners.after.event_stopped[SUBSCRIPTION_ID] = function(_, body)
    state.stopped_thread = body.threadId
    require("dap-view.threads").get_threads()
    for i, expr in ipairs(state.watched_expressions) do
        eval.eval_expr(expr, function(result)
            state.updated_evaluations[i] = state.expression_results[i]
                and state.expression_results[i] ~= result
            state.expression_results[i] = result
        end)
    end
end

dap.listeners.after.initialize[SUBSCRIPTION_ID] = function(session, _)
    if session.capabilities.exceptionBreakpointFilters then
        state.exceptions_options = vim.iter(session.capabilities.exceptionBreakpointFilters)
            :map(function(filter)
                return { enabled = filter.default, exception_filter = filter }
            end)
            :totable()
    end
    -- Remove applied filters from view when initializing a new session
    -- Since we don't store the applied filters between sessions
    -- (i.e., we always override with the defaults from the adapter on a new session)
    -- Therefore, the exceptions view could look outdated
    --
    -- Another approach would be to actually store the filters and reapply them.
    -- However, to handle different adapters, we'd have to filter and keep only
    -- the options for the current adapter
    if state.current_section == "exceptions" then
        exceptions.show()
    end
end

dap.listeners.after.event_terminated[SUBSCRIPTION_ID] = function()
    if state.current_section == "threads" then
        threads.show()
    end
    for k in ipairs(state.expression_results) do
        state.expression_results[k] = nil
    end
end
