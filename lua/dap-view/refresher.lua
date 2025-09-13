local state = require("dap-view.state")
local threads = require("dap-view.threads.view")
local scopes = require("dap-view.scopes.view")
local sessions = require("dap-view.sessions.view")
local exceptions = require("dap-view.exceptions.view")
local util = require("dap-view.util")

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
    end

    if util.is_buf_valid(state.bufnr) then
        if state.current_section == "scopes" then
            scopes.refresh()
        elseif state.current_section == "sessions" then
            sessions.refresh()
        end
    end
end

return M
