require("dap-view.highlight")
require("dap-view.autocmds")
-- Connect hooks to listen to DAP events
require("dap-view.events")

local actions = require("dap-view.actions")

local M = {}

---@param config dapview.Config?
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

---@param expr? string
M.add_expr = function(expr)
    actions.add_expr(expr)
end

---@param view dapview.SectionType
M.jump_to_view = function(view)
    actions.jump_to_view(view)
end

---@param view dapview.SectionType
M.show_view = function(view)
    actions.show_view(view)
end

return M
