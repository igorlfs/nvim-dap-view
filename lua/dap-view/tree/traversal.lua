local adapter = require("dap-view.util.adapter")

local M = {}

---Does not count sessions that dot not have terminals (`term_buf`)
---@param sessions table<number,dap.Session>
---@param acc dap.Session[]
---@return dap.Session[]
local function fold_sessions(sessions, acc)
    for _, session in pairs(sessions) do
        local js_adapter = adapter.is_js_adapter(session.config.type)

        -- Do not include top-level js-debug-adapter session
        -- But include all of its children
        if (js_adapter and not session.term_buf) or (session.term_buf and not js_adapter) then
            table.insert(acc, session)
        end
        for _, child in pairs(session.children) do
            fold_sessions({ child }, acc)
        end
    end
    return acc
end

---@generic T
---@param sessions table<number,dap.Session>
M.flatten_sessions = function(sessions)
    return fold_sessions(sessions, {})
end

return M
