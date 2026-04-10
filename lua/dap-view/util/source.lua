local M = {}

---@param f dap.StackFrame
M.source_exists = function(f)
    return f.source ~= nil and f.source.path ~= nil and vim.uv.fs_stat(f.source.path) ~= nil
end

return M
