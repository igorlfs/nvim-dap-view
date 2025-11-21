local dap = require("dap")

local state = require("dap-view.state")
local util = require("dap-view.views.util")

local M = {}

local log = vim.log.levels

---@param line integer
---@param switchbuffun? dapview.SwitchBufFun
M.jump_and_set_frame = function(line, switchbuffun)
    local line_content = vim.fn.getline(".")

    if string.find(line_content, "\t") then
        local frame = state.frames_by_line[line]
        if frame then
            local path = state.frame_paths_by_frame_id[frame.id]
            local lnum = state.frame_line_by_frame_id[frame.id]

            util.jump_to_location(path, lnum, nil, switchbuffun)

            local session = assert(dap.session(), "has active session")
            session:_frame_set(frame)
        end
    else
        vim.notify("Can only jump to a frame", log.INFO)
    end
end

return M
