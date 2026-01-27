local state = require("dap-view.state")

local M = {}

---@param line number
M.expand_or_collapse = function(line)
    if not require("dap-view.guard").expect_stopped() then
        return
    end

    local path = state.line_to_variable_path[line]

    local scope = state.line_to_scope_name[line]

    if scope then
        if vim.tbl_contains(state.collapsed_scopes, scope) then
            state.collapsed_scopes = vim.iter(state.collapsed_scopes)
                :filter(
                    ---@param s string
                    function(s)
                        return s ~= scope
                    end
                )
                :totable()
        else
            table.insert(state.collapsed_scopes, scope)
        end

        return true
    elseif path then
        state.variable_path_is_expanded[path] = not state.variable_path_is_expanded[path]

        return true
    else
        vim.notify("Nothing to expand")
    end
end

return M
