local M = {}

---@generic T
---@param tbl T[]
local sorted_keys = function(tbl)
    local keys = {}
    for k in pairs(tbl) do
        table.insert(keys, k)
    end
    table.sort(keys)
    return keys
end

---@generic T
---@param tbl T[]
---@param val T
---@return [integer, T[]]?
M.index_of = function(tbl, val)
    -- We need to sort to handle tables with gaps
    local keys = sorted_keys(tbl)

    for i, k in ipairs(keys) do
        if tbl[k] == val then
            return { i, keys }
        end
    end
    return nil
end

return M
