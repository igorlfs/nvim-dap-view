local state = require("dap-view.state")

local M = {}

---@param line number
M.set_value = function(line)
    if not require("dap-view.guard").expect_stopped() then
        return
    end

    local variable_path = state.line_to_variable_path[line]

    local redraw = false

    if variable_path then
        local variable_value = state.variable_path_to_value[variable_path]
        local parent_reference = state.variable_path_to_parent_reference[variable_path]
        local variable_name = state.variable_path_to_name[variable_path]
        local evaluate_name = state.variable_path_to_evaluate_name[variable_path]

        vim.ui.input({ prompt = "New value: ", default = variable_value }, function(value)
            if value then
                require("dap-view.views.set").set_value(
                    parent_reference,
                    variable_name,
                    value,
                    evaluate_name,
                    variable_path
                )

                redraw = true
            end
        end)
    end

    return redraw
end

---@param line number
M.jump_to_parent = function(line)
    local variable_path = state.line_to_variable_path[line]

    if variable_path then
        local jump_to_line = state.variable_path_to_parent_line[variable_path]

        if jump_to_line then
            require("dap-view.views.util").jump_to_parent(jump_to_line)
        end
    end
end

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
