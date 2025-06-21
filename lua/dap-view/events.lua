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

        -- Avoid creating useless buffers for child sessions
        if new.parent == nil then
            if not state.term_bufnrs[new.id] then
                state.term_bufnrs[new.id] = term.setup_term_win_cmd()

                if not (term_config.start_hidden or vim.tbl_contains(config.winbar.sections, "console")) then
                    term.open_term_buf_win()
                end
            end
        else
            state.term_bufnrs[new.id] = state.term_bufnrs[new.parent.id]
        end

        if not vim.tbl_contains(term_config.hide, state.current_adapter) then
            term.switch_term_buf()
        end
        -- Ugly hack but it sorta works
        vim.defer_fn(function()
            require("dap-view.exceptions").update_exception_breakpoints_filters()
        end, 1000)
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

        if session.current_frame ~= nil and util.is_win_valid(state.winnr) then
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

dap.listeners.after.initialize[SUBSCRIPTION_ID] = function(session)
    local adapter = session.config.type
    if state.exceptions_options[adapter] == nil then
        state.exceptions_options[adapter] = vim
            .iter(session.capabilities.exceptionBreakpointFilters or {})
            ---@param filter dap.ExceptionBreakpointsFilter
            :map(function(filter)
                return { enabled = filter.default, exception_filter = filter }
            end)
            :totable()
    end
    if state.current_section == "exceptions" then
        exceptions.show()
    end
end

dap.listeners.after.event_terminated[SUBSCRIPTION_ID] = function(session)
    -- Refresh threads view on exit to avoid showing outdated trace
    if state.current_section == "threads" then
        threads.show()
    end
    if state.current_section == "exceptions" then
        exceptions.show()
    end

    -- TODO find a cleaner way to dispose of these buffers
    local term_bufnr = state.term_bufnrs[session.id]
    if util.is_buf_valid(term_bufnr) then
        vim.api.nvim_buf_delete(term_bufnr, { force = true })
    end
    for k, v in pairs(state.term_bufnrs) do
        if v == term_bufnr then
            state.term_bufnrs[k] = nil
        end
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
