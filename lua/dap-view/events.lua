local dap = require("dap")
local cursor = require("dap-view.util.cursor")

local state = require("dap-view.state")
local breakpoints = require("dap-view.breakpoints.view")
local watches = require("dap-view.watches.view")
local threads = require("dap-view.threads.view")
local exceptions = require("dap-view.exceptions.view")
local term = require("dap-view.term.init")
local eval = require("dap-view.watches.eval")
local setup = require("dap-view.setup")

local SUBSCRIPTION_ID = "dap-view"

local api = vim.api

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
    -- To handle these scenarios, we have to delete the terminal buffer
    -- However, if we always close the terminal, dap-view will be shifted very quickly (if open),
    -- causing a flickering effect.
    --
    -- To address that, we only delete the terminal buffer if the new session has a different adapter
    -- (which should cover most scenarios where the flickering would occur)
    --
    -- However, do not try to delete the buffer on the first session,
    -- as it conflicts with bootstrapping the terminal window.
    -- See: https://github.com/igorlfs/nvim-dap-view/issues/18
    if state.last_active_adapter and state.last_active_adapter ~= adapter then
        term.force_delete_term_buf()
    end
    state.last_active_adapter = adapter

    term.setup_term_win_cmd()

    local separate_term_win = not vim.tbl_contains(setup.config.winbar.sections, "console")
    if not setup.config.windows.terminal.start_hidden and separate_term_win then
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
    if state.winnr and api.nvim_win_is_valid(state.winnr) then
        vim.defer_fn(function()
            local line_count = api.nvim_buf_line_count(state.bufnr)
            state.cursor_pos[1] = math.min(state.cursor_pos[1], line_count)
            api.nvim_win_set_cursor(state.winnr, state.cursor_pos)
            api.nvim_win_call(state.winnr, function()
                vim.cmd.normal("zz")
            end)
        end, 10)
    end
end

dap.listeners.after.stackTrace[SUBSCRIPTION_ID] = function()
    if state.current_section == "threads" then
        threads.show()
    end
end

dap.listeners.before.variables[SUBSCRIPTION_ID] = function()
    cursor.restore_cursor_position()
end

dap.listeners.before.event_continued[SUBSCRIPTION_ID] = function()
    cursor.restore_cursor_position()
end

dap.listeners.before.event_stopped[SUBSCRIPTION_ID] = function()
    cursor.restore_cursor_position()
end

dap.listeners.after.event_stopped[SUBSCRIPTION_ID] = function(_, body)
    state.stopped_thread = body.threadId

    require("dap-view.threads").get_threads()

    for i, expr in ipairs(state.watched_expressions) do
        eval.eval_expr(expr, function(result)
            local has_changed = state.expression_results[i] ~= result
            state.updated_evaluations[i] = state.expression_results[i] and has_changed
            state.expression_results[i] = result
        end)
    end
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

    -- Clear evaluations so new sessions don't get highlighted as changed
    for k in ipairs(state.expression_results) do
        state.expression_results[k] = nil
    end
end
