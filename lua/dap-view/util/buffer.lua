local M = {}

local api = vim.api

---@param bufnr integer
---@param callback fun(): nil
M.quit_buf_autocmd = function(bufnr, callback)
    api.nvim_create_autocmd("BufDelete", {
        buffer = bufnr,
        once = true,
        callback = callback,
    })
end

return M
