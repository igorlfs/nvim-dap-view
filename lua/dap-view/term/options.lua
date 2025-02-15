local M = {}

---@param winnr integer
---@param bufnr integer
M.set_options = function(winnr, bufnr)
    local win = vim.wo[winnr][0]
    win.scrolloff = 0
    win.wrap = false
    win.number = false
    win.relativenumber = false
    win.winfixheight = true
    win.statuscolumn = ""
    win.foldcolumn = "0"
    win.winfixbuf = true

    local buf = vim.bo[bufnr]
    buf.filetype = "dap-view-term"
    -- Can't set the buftype here, see https://github.com/neovim/neovim/issues/31457
end

return M
