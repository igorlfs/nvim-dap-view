local M = {}

---@generic T
---@param tbl T[]
---@param val T
M.index_of = function(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then
            return i
        end
    end
    return nil
end

return M
