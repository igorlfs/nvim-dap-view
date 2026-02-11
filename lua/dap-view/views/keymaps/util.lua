local state = require("dap-view.state")

local M = {}

---@param lhs string|string[]
---@param rhs string|function
---@param buf? integer
---@param mode? string|string[]
function M.keymap(lhs, rhs, buf, mode)
    mode = mode or "n"
    if type(lhs) == "string" then
        lhs = { lhs }
    end
    for _, v in ipairs(lhs) do
        vim.keymap.set(mode, v, rhs, { buffer = buf or state.bufnr, nowait = true })
    end
end

return M
