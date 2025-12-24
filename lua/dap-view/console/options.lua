local setup = require("dap-view.setup")

local M = {}

---@param winnr integer
M.set_win_options = function(winnr)
    local win = vim.wo[winnr][0]

    win.scrolloff = 0
    win.wrap = false
    win.number = false
    win.relativenumber = false
    win.statuscolumn = ""
    win.foldcolumn = "0"
    win.winfixbuf = true

    local position = setup.config.windows.position
    local pos = (type(position) == "function" and position and position()) or (type(position) == "string" and position)

    -- That's a bit confusing, but since the terminal split is just created from a top level split,
    -- to keep the proportions consistent, we just have to follow what the top level split says
    if pos == "above" or pos == "below" then
        win.winfixheight = true
    else
        win.winfixwidth = true
    end
end

return M
