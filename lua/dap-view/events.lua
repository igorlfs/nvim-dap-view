local dap = require("dap")

local state = require("dap-view.state")
local breakpoints = require("dap-view.breakpoints.view")
local scopes = require("dap-view.scopes.view")
local util = require("dap-view.util")
local threads = require("dap-view.threads.view")
local exceptions = require("dap-view.exceptions.view")
local term = require("dap-view.term.init")
local eval = require("dap-view.watches.eval")
local setup = require("dap-view.setup")
local winbar = require("dap-view.options.winbar")

local SUBSCRIPTION_ID = "dap-view"

dap.listeners.on_session[SUBSCRIPTION_ID] = function(_, new)
    if new then
        local config = setup.config
        local term_config = config.windows.terminal

        state.current_session_id = new.id
        state.current_adapter = new.config.type

        if not state.term_bufnrs[new.id] then
            state.term_bufnrs[new.id] = term.setup_term_win_cmd()

            if not (term_config.start_hidden or vim.tbl_contains(config.winbar.sections, "console")) then
                term.open_term_buf_win()
            end
        end

        if not vim.tbl_contains(term_config.hide, state.current_adapter) then
            term.switch_term_buf()
        end
    else
        state.current_session_id = nil
        state.current_adapter = nil
    end
end

dap.listeners.after.setBreakpoints[SUBSCRIPTION_ID] = function()
    if state.current_section == "breakpoints" then
        breakpoints.show()
    end
end

dap.listeners.after.scopes[SUBSCRIPTION_ID] = function(session)
    -- nvim-dap needs a buffer to operate
    if state.current_section == "scopes" and util.is_buf_valid(state.bufnr) then
        scopes.refresh()
    end
    if state.current_section == "threads" then
        require("dap-view.views").switch_to_view("threads")

        if session.current_frame ~= nil and state.winnr then
            require("dap-view.threads").track_cursor_position(session.current_frame.id)
        end
    end

    -- Do not use `event_stopped`
    -- It may cause race conditions
    for expr, _ in pairs(state.watched_expressions) do
        eval.eval_expr(expr)
    end
end

dap.listeners.after.variables[SUBSCRIPTION_ID] = function()
    if state.current_section == "watches" then
        require("dap-view.views").switch_to_view("watches")
    end
end

dap.listeners.after.threads[SUBSCRIPTION_ID] = function(_, err)
    state.threads_error = nil

    if err then
        state.threads_error = tostring(err)
    end

    winbar.redraw_controls()
end

dap.listeners.after.stackTrace[SUBSCRIPTION_ID] = function(_, err, _, payload)
    local threadId = payload.threadId

    state.stack_trace_errors[threadId] = nil

    if err then
        state.stack_trace_errors[threadId] = tostring(err)
    end
end

dap.listeners.after.setExpression[SUBSCRIPTION_ID] = function()
    eval.reeval()
end

dap.listeners.after.setVariable[SUBSCRIPTION_ID] = function()
    eval.reeval()
end

dap.listeners.after.initialize[SUBSCRIPTION_ID] = function(session, _)
    state.exceptions_options = vim.iter(session.capabilities.exceptionBreakpointFilters or {})
        :map(function(filter)
            return { enabled = filter.default, exception_filter = filter }
        end)
        :totable()
    -- Remove applied filters from view when initializing a new session
    -- Since we don't store the applied filters between sessions
    -- (i.e., we always override with the defaults from the adapter on a new session)
    -- Therefore, the exceptions view could look outdated
    --
    -- Also, we can't just update the filters at this stage (after the initialize request)
    -- due to how the initialization works: setExceptionBreakpoints happens after initialize
    -- (with the default configuration)
    -- See https://microsoft.github.io/debug-adapter-protocol/specification#Events_Initialized
    if state.current_section == "exceptions" then
        exceptions.show()
    end
end

dap.listeners.after.event_terminated[SUBSCRIPTION_ID] = function()
    -- Refresh threads view on exit to avoid showing outdated trace
    if state.current_section == "threads" then
        threads.show()
    end

    winbar.redraw_controls()
end

--- Refresh winbar on dap session state change events not having a dedicated event handler
local events = {
    "continue",
    "disconnect",
    "event_exited",
    "event_stopped",
    "restart",
}

for _, event in ipairs(events) do
    dap.listeners.after[event][SUBSCRIPTION_ID] = winbar.redraw_controls
end
