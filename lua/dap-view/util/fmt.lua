local M = {}

---Yoinked from https://codeberg.org/mfussenegger/nvim-dap/src/commit/e47878dcf1ccc30136b30d19ab19fe76946d61cd/lua/dap/utils.lua#L4-L16
---With one notable difference: ignores `showUser` (i.e., always shows a message)
---The JS debug adapter often returns `showUser = false`, but for our use case,
---we are always interested in showing the error (which is much more helpful than the default "Undefined error")
---@param err dap.ErrorResponse
---@return string
M.dap_error = function(err)
    local body = err.body or {}
    if body.error then
        local msg = body.error.format
        for key, val in pairs(body.error.variables or {}) do
            msg = msg:gsub("{" .. key .. "}", val)
        end
        return msg
    end
    return err.message
end

return M
