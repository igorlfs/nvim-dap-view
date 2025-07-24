local dap = require("dap")

local state = require("dap-view.state")
local util = require("dap-view.views.util")

local M = {}

local log = vim.log.levels

---@param lnum number
---@param force_split? boolean
M.jump_or_noop = function(lnum, force_split)
    local line = vim.fn.getline(".")

    if string.find(line, "\t") then
        util.jump_to_location("^\t(.-)|(%d+)|", nil, force_split)

        local frame = state.frames_by_line[lnum]
        if frame then
            local session = assert(dap.session(), "has active session")
            session:_frame_set(frame)
        end
    else
        vim.notify("Can't jump to a thread", log.INFO)
    end
end

return M
