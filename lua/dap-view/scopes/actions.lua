local state = require("dap-view.state")

local M = {}

---@param lnum number
M.expand_or_collapse = function(lnum)
    local path = state.line_to_path[lnum]

    if path then
        state.expanded_variables[path] = not state.expanded_variables[path]

        return true
    else
        vim.notify("Nothing to expand")
    end
end

return M
