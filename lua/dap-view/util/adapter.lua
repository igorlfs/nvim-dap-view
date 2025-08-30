local M = {}

---@param adapter string
M.is_js_adapter = function(adapter)
    return vim.tbl_contains({
        "pwa-node",
        "pwa-chrome",
    }, adapter)
end

return M
