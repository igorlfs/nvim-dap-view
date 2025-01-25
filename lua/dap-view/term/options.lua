local M = {}

local state = require("dap-view.state")

M.set_options = function()
    local win = vim.wo[state.term_winnr][0]
    win.scrolloff = 0
    win.wrap = false
    win.number = false
    win.relativenumber = false
    win.winfixheight = true
    win.statuscolumn = ""
    win.foldcolumn = "0"
    win.winfixbuf = true

    local buf = vim.bo[state.term_bufnr]
    buf.filetype = "dap-view-term"
    vim.api.nvim_set_option_value("buftype", "nofile", { scope = "local", buf = state.term_bufnr })
end

return M
