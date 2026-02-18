local global = require("dap-view.globals")

local M = {}

local nightly = vim.fn.has("nvim-0.12") == 1

---@param text string
---@param group string
---@param inherit boolean?
---@param clean boolean?
M.hl = function(text, group, inherit, clean)
    local field = (inherit and nightly) and "$" or "#"
    local part = "%" .. field .. global.HL_PREFIX .. group .. field .. text
    if clean or clean == nil then
        return part .. "%*"
    end
    return part
end

---@param text string
---@param module string
---@param handler string
---@param idx integer
M.clickable = function(text, module, handler, idx)
    return "%" .. idx .. "@v:lua.require'" .. module .. "'." .. handler .. "@" .. text .. "%T"
end

return M
