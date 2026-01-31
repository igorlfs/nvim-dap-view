local state = require("dap-view.state")

local M = {}

local api = vim.api

---@param current_frame_id number
M.track_cursor_position = function(current_frame_id)
    local line_count = api.nvim_buf_line_count(state.bufnr)

    for k, v in pairs(state.frames_by_line) do
        if v.id == current_frame_id then
            -- Sometimes vscode-js-debug goes wacko mode and may trigger a tracking with a non-existent position
            if k <= line_count then
                api.nvim_win_set_cursor(state.winnr, { k, 0 })
            end
        end
    end
end

return M
