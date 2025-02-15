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

---@param hide_terminal? boolean
M.close = function(hide_terminal)
    actions.close(hide_terminal)
end

---@param hide_terminal? boolean
M.toggle = function(hide_terminal)
    actions.toggle(hide_terminal)
end

M.add_expr = function()
    actions.add_expr()
end

return M
