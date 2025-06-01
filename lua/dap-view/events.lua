local dap = require("dap")

local state = require("dap-view.state")
local breakpoints = require("dap-view.breakpoints.view")
local scopes = require("dap-view.scopes.view")
local threads = require("dap-view.threads.view")
local exceptions = require("dap-view.exceptions.view")
local term = require("dap-view.term.init")
local eval = require("dap-view.watches.eval")
local setup = require("dap-view.setup")
local winbar = require("dap-view.options.winbar")
local util = require("dap-view.util")
local console = require("dap-view.console")

local SUBSCRIPTION_ID = "dap-view"

dap.listeners.before.initialize[SUBSCRIPTION_ID] = function(session, _)
    state.current_adapter = session.config.type
    state.current_session_id = session.id

    if state.fallback_term_bufnr then
        state.term_bufnrs[state.current_session_id] = state.fallback_term_bufnr
        state.fallback_term_bufnr = nil
    end

    term.setup_term_win_cmd()

    dap.defaults.fallback.terminal_win_cmd = function()
        local term_bufnr = state.term_bufnrs[state.current_session_id]

        assert(term_bufnr, "Failed to get term bufnr")

        return term_bufnr
    end

    local separate_term_win = not vim.tbl_contains(setup.config.winbar.sections, "console")

    local is_console = state.current_section == "console"

    if not setup.config.windows.terminal.start_hidden then
        if separate_term_win then
            term.open_term_buf_win()
        elseif util.is_win_valid(state.winnr) and is_console then
            console.setup_console(state.winnr)
        end
    end
end

dap.listeners.after.setBreakpoints[SUBSCRIPTION_ID] = function()
    if state.current_section == "breakpoints" then
        breakpoints.show()
    end
end

dap.listeners.after.scopes[SUBSCRIPTION_ID] = function(session)
    -- nvim-dap needs a buffer to operate
    if state.current_section == "scopes" and state.bufnr then
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

dap.listeners.after.event_stopped[SUBSCRIPTION_ID] = function(session)
    state.current_session_id = session.id

    local separate_term_win = not vim.tbl_contains(setup.config.winbar.sections, "console")
    local is_console = state.current_section == "console"

    local cond_main_win = not separate_term_win and util.is_win_valid(state.winnr) and is_console
    local cond_term_win = separate_term_win and util.is_win_valid(state.term_winnr)

    local winnr = separate_term_win and state.term_winnr or state.winnr

    if winnr and (cond_main_win or cond_term_win) then
        console.setup_console(winnr)
    end

    winbar.redraw_controls()
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
    state.current_session_id = nil

    -- Refresh threads view on exit to avoid showing outdated trace
    if state.current_section == "threads" then
        threads.show()
    end

    winbar.redraw_controls()
end

dap.listeners.after.disconnect[SUBSCRIPTION_ID] = function()
    state.current_session_id = nil

    winbar.redraw_controls()
end

--- Refresh winbar on dap session state change events not having a dedicated event handler
local events = {
    "continue",
    "event_exited",
    "restart",
}

for _, event in ipairs(events) do
    dap.listeners.after[event][SUBSCRIPTION_ID] = winbar.redraw_controls
end
