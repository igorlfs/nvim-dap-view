local state = require("dap-view.state")
local adapter = require("dap-view.util.adapter")

local M = {}

---@param children dapview.VariablePack[]
---@param reference number
---@return dapview.VariablePack?
local function dfs(children, reference)
    for _, v in pairs(children) do
        if v.variable.variablesReference == reference then
            return v
        end
        if v.children and type(v.children) ~= "string" then
            ---@cast v dapview.VariablePackStrict
            local ref = dfs(v.children, reference)
            if ref then
                return ref
            end
        end
    end
end

---@param reference number
---@return dapview.VariablePack?
M.find_node = function(reference)
    for _, v in pairs(state.watched_expressions) do
        local children = v.children
        if children and type(children) ~= "string" then
            local ref = dfs(children, reference)
            if ref then
                return ref
            end
        end
    end
end

---@param sessions table<number,dap.Session>
---@param acc dap.Session[]
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
