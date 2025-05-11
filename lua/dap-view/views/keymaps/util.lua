local state = require("dap-view.state")

local M = {}

---@param lhs string
---@param rhs string|function
---@param opts? table
---@param mode? string|string[]
function M.keymap(lhs, rhs, opts, mode)
    opts = opts == nil and { buffer = state.bufnr, nowait = true } or opts --[[@as table]]
    mode = mode or "n"
    vim.keymap.set(mode, lhs, rhs, opts)
end

return M
