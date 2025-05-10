local state = require("dap-view.state")

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

return M
