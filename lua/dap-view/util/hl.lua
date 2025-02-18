local state = require("dap-view.state")
local globals = require("dap-view.globals")

local M = {}

---@param hl_group string
---@param start [integer,integer]
---@param finish [integer,integer]
M.hl_range = function(hl_group, start, finish)
    vim.hl.range(state.bufnr, globals.NAMESPACE, "NvimDapView" .. hl_group, start, finish)
end

return M
