local M = {}

---@param winnr integer
M.set_win_options = function(winnr)
    -- We actually want other buffers (e.g, term_bufs from other sessions) to inherit these options
    local win = vim.wo[winnr]
    win.scrolloff = 0
    win.wrap = false
    win.number = false
    win.relativenumber = false
    win.winfixheight = true
    win.statuscolumn = ""
    win.foldcolumn = "0"
    win.winfixbuf = true
end

return M
