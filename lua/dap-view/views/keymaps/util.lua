local state = require("dap-view.state")

local M = {}

---@param lhs string
---@param rhs string|function
---@param buf? integer
---@param mode? string|string[]
function M.keymap(lhs, rhs, buf, mode)
    mode = mode or "n"
    vim.keymap.set(mode, lhs, rhs, { buffer = buf or state.bufnr, nowait = true })
end

return M
