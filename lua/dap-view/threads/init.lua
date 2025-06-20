local state = require("dap-view.state")

local M = {}

local api = vim.api

---@param current_frame_id number
M.track_cursor_position = function(current_frame_id)
    for k, v in pairs(state.frames_by_line) do
        if v.id == current_frame_id then
            api.nvim_win_set_cursor(state.winnr, { k, 1 })
        end
    end
end

return M
