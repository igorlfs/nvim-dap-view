local state = require("dap-view.state")

local M = {}

local api = vim.api

---@param cb fun(line: integer): nil
---@param winnr integer?
M.at_cursor = function(cb, winnr)
    local cursor_line = api.nvim_win_get_cursor(winnr or state.winnr)[1]

    cb(cursor_line)
end

return M
