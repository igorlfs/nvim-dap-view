local state = require("dap-view.state")
local setup = require("dap-view.setup")

local M = {}

M.set_options = function()
    local win = vim.wo[state.winnr][0]
    win.scrolloff = 99
    win.wrap = false
    win.number = false
    win.relativenumber = false
    win.cursorlineopt = "line"
    win.cursorline = true
    win.statuscolumn = ""
    win.foldcolumn = "0"
    win.winfixbuf = true

    local position = setup.config.windows.position
    local pos = (type(position) == "function" and position and position()) or (type(position) == "string" and position)

    if pos == "above" or pos == "below" then
        win.winfixheight = true
    else
        win.winfixwidth = true
    end

    local buf = vim.bo[state.bufnr]
    buf.buftype = "nofile"
    buf.swapfile = false
    buf.modifiable = false
    buf.filetype = "dap-view"
end

return M
