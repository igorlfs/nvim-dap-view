require("dap-view.highlight")
-- Connect hooks to listen to DAP events
require("dap-view.events")

local actions = require("dap-view.actions")

local M = {}

---@param config Config?
M.setup = function(config)
    require("dap-view.setup").setup(config)
end

M.open = function()
    actions.open()
end

M.close = function()
    actions.close()
end

M.hide = function()
    actions.hide()
end

M.toggle = function()
    actions.toggle()
end

M.add_expr = function()
    actions.add_expr()
end

return M
