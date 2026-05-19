local M = {}

---@param f dap.StackFrame
M.source_exists = function(f)
    -- We deliberately skip checking `vim.uv.fs_stat` because the file may not exist,
    -- if it came from a Source request (aka dap-src buffer)
    return f.source ~= nil and f.source.path ~= nil
end

return M
