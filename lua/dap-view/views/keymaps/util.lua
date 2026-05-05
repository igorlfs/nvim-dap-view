local state = require("dap-view.state")

local M = {}

---@param lhs string|string[]
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
---@param mode? string|string[]
function M.keymap(lhs, rhs, opts, mode)
    mode = mode or "n"
    if type(lhs) == "string" then
        lhs = { lhs }
    end

    opts = opts or {}
    opts.nowait = true
    opts.buffer = opts.buffer or state.bufnr

    for _, v in ipairs(lhs) do
        vim.keymap.set(mode, v, rhs, opts)
    end
end

---@param lhs string|string[]
---@param opts? vim.keymap.del.Opts
---@param mode? string|string[]
function M.keymap_del(lhs, opts, mode)
    mode = mode or "n"
    if type(lhs) == "string" then
        lhs = { lhs }
    end

    opts = opts or {}
    opts.buffer = opts.buffer or state.bufnr

    for _, v in ipairs(lhs) do
        vim.keymap.del(mode, v, opts)
    end
end

return M
