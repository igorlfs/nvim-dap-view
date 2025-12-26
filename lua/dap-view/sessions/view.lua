local dap = require("dap")

local views = require("dap-view.views")
local state = require("dap-view.state")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")

local M = {}

---@param children table<number,dap.Session>
---@param focused_id number
---@param line number
local function show_children_sessions(children, focused_id, line)
    for _, session in pairs(children) do
        local content = session.id .. ": " .. session.config.name

        local parent = session.parent
        local num_parents = 0
        while parent ~= nil do
            parent = parent.parent
            num_parents = num_parents + 1
        end

        local prefix = string.rep("  ", num_parents)
        local indented_content = prefix .. content

        util.set_lines(state.bufnr, line, line, true, { indented_content })

        if focused_id == session.id then
            hl.hl_range("FrameCurrent", { line, 0 }, { line, -1 })
        end

        state.sessions_by_line[line + 1] = session

        line = line + 1

        line = show_children_sessions(session.children, focused_id, line)
    end

    return line
end

M.show = function()
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        local focused = dap.session()

        if views.cleanup_view(focused == nil, "No active session") then
            return
        end

        ---@cast focused dap.Session

        local line = 0

        line = show_children_sessions(dap.sessions(), focused.id, line)

        util.set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
