local dap = require("dap")

local state = require("dap-view.state")

local M = {}

---@param line integer
M.switch_to_session = function(line)
    local session = state.sessions_by_line[line]

    if session == nil then
        vim.notify("No session under the cursor")
        return
    end

    dap.set_session(session)
end

return M
