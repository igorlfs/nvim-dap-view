local state = require("dap-view.state")

local M = {}

---@param line number
M.expand_or_collapse = function(line)
    if not require("dap-view.guard").expect_stopped() then
        return
    end

    local path = state.line_to_variable_path[line]

    if path then
        state.variable_path_is_expanded[path] = not state.variable_path_is_expanded[path]

        return true
    else
        vim.notify("Nothing to expand")
    end
end

return M
