local dap = require("dap")

local state = require("dap-view.state")
local util = require("dap-view.views.util")

local M = {}

local api = vim.api
local log = vim.log.levels

M.jump_or_noop = function()
    local line = vim.fn.getline(".")

    if string.find(line, "\t") then
        util.jump_to_location("^\t(.-)|(%d+)|")

        -- Set frame
        local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]
        local frame = state.frames_by_line[cursor_line]
        if frame then
            local session = assert(dap.session(), "has active session")
            session:_frame_set(frame)
        end
    else
        vim.notify("Can't jump to a thread", log.INFO)
    end
end

return M
