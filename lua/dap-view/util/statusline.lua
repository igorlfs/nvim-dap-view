local M = {}
local global = require("dap-view.globals")

---@param text string
---@param group string
M.hl = function(text, group)
    return "%#" .. global.HL_PREFIX .. group .. "#" .. text .. "%*"
end

---@param text string
---@param module string
---@param handler string
---@param idx integer
M.clickable = function(text, module, handler, idx)
    return "%" .. idx .. "@v:lua.require'" .. module .. "'." .. handler .. "@" .. text .. "%T"
end

return M
