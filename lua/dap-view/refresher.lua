local state = require("dap-view.state")
local threads = require("dap-view.threads.view")
local exceptions = require("dap-view.exceptions.view")
local eval = require("dap-view.watches.eval")

local M = {}

---Refresh views that may get updated on session events
---
---threads => may get outdated when finishing / switching sessions
---exceptions => no longer valid after finishing a session
---scopes => no longer valid after finishing a session
---sessions => obviously needs to be updated when switching / finishing a session
M.refresh_session_based_views = function()
    if state.current_section == "threads" then
        threads.show()
    elseif state.current_section == "exceptions" then
        exceptions.show()
    elseif state.current_section == "watches" then
        require("dap-view.views").switch_to_view("watches")
    elseif state.current_section == "sessions" then
        require("dap-view.views").switch_to_view("sessions")
    elseif state.current_section == "scopes" then
        coroutine.wrap(function()
            require("dap-view.views").switch_to_view("scopes")
        end)()
    end
end

M.refresh_all_expressions = function()
    coroutine.wrap(function()
        for expr, _ in pairs(state.watched_expressions) do
            eval.evaluate_expression(expr, true)
        end

        if state.current_section == "watches" then
            require("dap-view.views").switch_to_view("watches")
        end
    end)()
end

return M
