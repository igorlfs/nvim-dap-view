local dap = require("dap")

local state = require("dap-view.state")
local breakpoints = require("dap-view.breakpoints.view")
local scopes = require("dap-view.scopes.view")
local sessions = require("dap-view.sessions.view")
local util = require("dap-view.util")
local term = require("dap-view.console.view")
local eval = require("dap-view.watches.eval")
local setup = require("dap-view.setup")
local refresher = require("dap-view.refresher")
local winbar = require("dap-view.options.winbar")
local traversal = require("dap-view.tree.traversal")
local scroll = require("dap-view.console.scroll")
local adapter_ = require("dap-view.util.adapter")

local SUBSCRIPTION_ID = "dap-view"

dap.listeners.on_session[SUBSCRIPTION_ID] = function(_, new)
    if new then
        local config = setup.config
        local term_config = config.windows.terminal

        state.current_session_id = new.id
        state.current_adapter = new.config.type

        -- Handle switching the buf if session is already initialized
        if term.fetch_term_buf(new) and not vim.tbl_contains(term_config.hide, state.current_adapter) then
            term.switch_term_buf()
        end

        refresher.refresh_session_based_views()

        -- Sync exception breakpoints
        -- Does not cover session initialization
        -- At this stage, the session is not fully initialized yet
        require("dap-view.exceptions").update_exception_breakpoints_filters()

        if new.initialized then
            -- Handle autoscrolling when switching sessions
            -- Straightforward way of taking into account "console" not being set
            if util.is_buf_valid(new.term_buf) and scroll.is_autoscrolling(new.term_buf) then
                local winnr = vim.tbl_contains(setup.config.winbar.sections, "console") and state.winnr
                    or state.term_winnr
                if util.is_win_valid(winnr) then
                    ---@cast winnr integer
                    scroll.scroll_to_bottom(winnr, new.term_buf)
                end
            end
            if new.stopped_thread_id then
                eval.reevaluate_all_expressions()
            end
        end
    else
        state.current_session_id = nil
        state.current_adapter = nil
    end
end

dap.listeners.after.event_initialized[SUBSCRIPTION_ID] = function()
    local config = setup.config
    local term_config = config.windows.terminal

    local has_console = vim.tbl_contains(config.winbar.sections, "console")
    local hidden_adapter = vim.tbl_contains(term_config.hide, state.current_adapter)
    local open_term = not term_config.start_hidden and not has_console and not hidden_adapter

    -- We can't setup inside `on_session` hook because at that stage the session does not have a `term_buf`
    term.setup_term_buf()

    -- `term_buf` must be setup before calling open
    if open_term then
        term.open_term_buf_win()
    end

    -- Enabling "console" has priority over hiding an adapter
    if has_console or not hidden_adapter then
        term.switch_term_buf()
    end

    -- In some scenarios we have to force a refresh after initializing a session
    -- For instance, for the sessions view, a child session might not be shown otherwise
    -- Steps: js-debug-adapter (chrome) + attach
    refresher.refresh_session_based_views()
end

dap.listeners.after.configurationDone[SUBSCRIPTION_ID] = function()
    -- Sync exception breakpoints for the newly initialized session
    -- This can't happen right after `event_initialized` because it can be overridden by session configuration
    -- (as a setExceptionBreakpoints request is fired during configuration)
    -- The downside is that not all adapters support `configurationDone`
    -- (though it's an old feature, so it should be widely available)
    require("dap-view.exceptions").update_exception_breakpoints_filters()
end

dap.listeners.after.setBreakpoints[SUBSCRIPTION_ID] = function()
    if state.current_section == "breakpoints" then
        breakpoints.show()
    end
end

dap.listeners.after.scopes[SUBSCRIPTION_ID] = function(session)
    -- nvim-dap needs a buffer to operate
    if util.is_buf_valid(state.bufnr) then
        if state.current_section == "scopes" then
            scopes.refresh()
        elseif state.current_section == "sessions" then
            sessions.refresh()
        end
    end
    if state.current_section == "threads" then
        require("dap-view.views").switch_to_view("threads")

        if session.current_frame ~= nil and util.is_win_valid(state.winnr) then
            require("dap-view.threads").track_cursor_position(session.current_frame.id)
        end
    end

    -- Do not use `event_stopped`
    -- It may cause race conditions
    eval.reevaluate_all_expressions()
end

local continue = { "event_continued", "continue" }

for _, listener in ipairs(continue) do
    dap.listeners.after[listener][SUBSCRIPTION_ID] = function()
        -- Program is no longer stopped, refresh threads to prevent user from jumping to a no longer accurate location
        if state.current_section == "threads" then
            require("dap-view.views").switch_to_view("threads")
        end

        winbar.redraw_controls()
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

dap.listeners.after.variables[SUBSCRIPTION_ID] = function()
    -- When setting a variable for some adapters, the request may be slow.
    -- And by the time we refresh the view "regularly", the data might not be up-to-date.
    -- To avoid dealing with such edge cases, we force redrawing after the variables request.
    -- This introduces an overrhead, but its robustness should be worth it
    if state.current_section == "watches" then
        require("dap-view.views").switch_to_view("watches")
    end
end

local reeval = { "setExpression", "setVariable" }

for _, listener in ipairs(reeval) do
    dap.listeners.after[listener][SUBSCRIPTION_ID] = eval.reevaluate_all_expressions
end

dap.listeners.after.initialize[SUBSCRIPTION_ID] = function(session)
    local adapter = session.config.type
    if state.exceptions_options[adapter] == nil then
        state.exceptions_options[adapter] = vim.iter(session.capabilities.exceptionBreakpointFilters or {})
            :map(
                ---@param filter dap.ExceptionBreakpointsFilter
                function(filter)
                    return { enabled = filter.default, exception_filter = filter }
                end
            )
            :totable()
    end
end

-- The debuggee has terminated
dap.listeners.after.event_terminated[SUBSCRIPTION_ID] = function(session)
    -- When terminating, outdated sessions may be shown
    -- As a workaround, do not refresh for the root session from js-debug-adapter
    -- Steps: js-debug-adapter (chrome) + attach
    local is_js_adapter = adapter_.is_js_adapter(session.config.type)

    if not is_js_adapter or session.parent then
        refresher.refresh_session_based_views()
    end

    winbar.redraw_controls()

    scroll.cleanup_autoscroll(session.term_buf)
end

-- The debuggee was disconnected, which may happen outside of a "regular termination"
dap.listeners.after.disconnect[SUBSCRIPTION_ID] = function(session)
    refresher.refresh_session_based_views()

    winbar.redraw_controls()

    scroll.cleanup_autoscroll(session.term_buf)
end

local winbar_redraw = { "event_exited", "event_stopped", "restart" }

for _, listener in ipairs(winbar_redraw) do
    dap.listeners.after[listener][SUBSCRIPTION_ID] = winbar.redraw_controls
end

local auto_open = { "attach", "launch" }

for _, listener in ipairs(auto_open) do
    dap.listeners.before[listener][SUBSCRIPTION_ID] = function()
        if setup.config.auto_toggle then
            require("dap-view.actions").open()
        end
    end
end

local auto_close = { "event_terminated", "disconnect" }

for _, listener in ipairs(auto_close) do
    dap.listeners.before[listener][SUBSCRIPTION_ID] = function()
        local auto_toggle = setup.config.auto_toggle

        if auto_toggle then
            local dap_sessions = traversal.flatten_sessions(dap.sessions())

            -- Auto toggle is a bit ambiguous if there are multiple sessions running
            -- Should we call close if a single session is finished, even if others are running?
            if #dap_sessions == 1 then
                require("dap-view.actions").close(not (auto_toggle == "keep_terminal"))
            end
        end
    end
end
