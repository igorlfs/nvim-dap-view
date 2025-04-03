local state = require("dap-view.state")

local M = {}

local api = vim.api

M.restore_cursor_position = function()
    if state.winnr and api.nvim_win_is_valid(state.winnr) then
        state.cursor_pos = api.nvim_win_get_cursor(state.winnr)
    end
end

return M
