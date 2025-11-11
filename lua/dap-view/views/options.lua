local state = require("dap-view.state")

local M = {}

M.set_options = function()
    local win = vim.wo[state.winnr][0]
    win.scrolloff = 99
    win.wrap = false
    win.number = false
    win.relativenumber = false
    -- TODO setting this up show depend if state is "below" or "above"
    win.winfixheight = true
    win.cursorlineopt = "line"
    win.cursorline = true
    win.statuscolumn = ""
    win.foldcolumn = "0"
    win.winfixbuf = true

    local buf = vim.bo[state.bufnr]
    buf.buftype = "nofile"
    buf.swapfile = false
    buf.filetype = "dap-view"
end

return M
