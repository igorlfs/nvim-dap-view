local state = require("dap-view.state")
local eval = require("dap-view.watches.eval")

local M = {}

---Refresh views that may get updated on session events
---
---threads => may get outdated when finishing / switching sessions
---exceptions => no longer valid after finishing a session
---scopes => no longer valid after finishing a session
---sessions => obviously needs to be updated when switching / finishing a session
M.refresh_session_based_views = function()
    if vim.tbl_contains({ "threads", "exceptions", "watches", "sessions" }, state.current_section) then
        require("dap-view.views").switch_to_view(state.current_section)
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
