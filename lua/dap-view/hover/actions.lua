local state = require("dap-view.state")
local guard = require("dap-view.guard")
local set = require("dap-view.views.set")

local M = {}

---@param line number
M.set_hover_expr = function(line)
    if not guard.expect_stopped() then
        return
    end

    local redraw = false

    if line == 1 then
        local expr = state.hovered_expression
        local default = (expr and expr.response and expr.response.result) or ""

        vim.ui.input({ prompt = "New value: ", default = default }, function(input)
            if input then
                set.set_expr(state.hover, input)

                redraw = true
            end
        end)
    else
        local path = state.line_to_hover_path[line]

        if path then
            local default = state.hover_path_to_value[path]
            local parent_reference = state.hover_path_to_parent_reference[path]
            local name = state.hover_path_to_name[path]
            local evaluate_name = state.hover_path_to_evaluate_name[path]

            vim.ui.input({ prompt = "New value: ", default = default }, function(input)
                if input then
                    require("dap-view.views.set").set_value(parent_reference, name, input, evaluate_name, path)

                    redraw = true
                end
            end)
        end
    end

    return redraw
end

---@param line number
M.jump_to_parent = function(line)
    local path = state.line_to_hover_path[line]

    if path then
        local jump_to_line = state.hover_path_to_parent_line[path]

        if jump_to_line then
            require("dap-view.views.util").jump_to_parent(jump_to_line, state.hover_winnr, state.hover_bufnr)
        end
    end
end

---@param line number
M.expand_or_collapse = function(line)
    if not guard.expect_stopped() then
        return
    end

    local path = state.line_to_hover_path[line]

    if line == 1 then
        state.hovered_expression.expanded = not state.hovered_expression.expanded

        return true
    elseif path then
        state.hover_path_is_expanded[path] = not state.hover_path_is_expanded[path]

        return true
    else
        vim.notify("Nothing to expand")
    end
end

return M
