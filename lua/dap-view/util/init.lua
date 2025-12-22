local M = {}

local api = vim.api

M.inverted_directions = {
    ["above"] = "below",
    ["below"] = "above",
    ["right"] = "left",
    ["left"] = "right",
}

---@param bufnr? integer
M.is_buf_valid = function(bufnr)
    return bufnr and api.nvim_buf_is_valid(bufnr)
end

---@param winnr? integer|false
M.is_win_valid = function(winnr)
    return winnr and api.nvim_win_is_valid(winnr)
end

---@param variable dap.Variable
---@param expanded boolean
---@return string
M.get_variable_prefix = function(variable, expanded)
    if variable.variablesReference > 0 then
        if expanded then
            return "▼ "
        else
            return "▶ "
        end
    end

    return ""
end

---@param expression dapview.ExpressionView
---@param expanded boolean
---@return string
M.get_expression_prefix = function(expression, expanded)
    if expression.children ~= nil then
        if expanded then
            return "▼ "
        else
            return "▶ "
        end
    end

    return ""
end

return M
