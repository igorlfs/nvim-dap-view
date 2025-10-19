local M = {}

---@param winnr integer
M.set_win_options = function(winnr)
    local win = vim.wo[winnr][0]

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
