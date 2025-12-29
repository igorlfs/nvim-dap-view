local state = require("dap-view.state")
local guard = require("dap-view.guard")
local eval = require("dap-view.watches.eval")
local set = require("dap-view.views.set")

local M = {}

---@param expr string
---@param default_expanded boolean
M.add_watch_expr = function(expr, default_expanded)
    if #expr == 0 or not guard.expect_stopped() then
        return false
    end

    eval.evaluate_expression(expr, default_expanded)

    state.expr_count = state.expr_count + 1

    return true
end

---@param line number
M.remove_watch_expr = function(line)
    local expression_view = state.expression_views_by_line[line]

    if expression_view then
        state.watched_expressions[expression_view.expression] = nil

        return expression_view
    else
        vim.notify("No expression under the under cursor")
    end
end

---@param line number
M.copy_watch_expr = function(line)
    local expression_view = state.expression_views_by_line[line]

    if expression_view then
        eval.copy_expr(expression_view.expression)
    else
        local variable_reference = state.variable_views_by_line[line]

        if variable_reference then
            local evaluate_name = variable_reference.view.variable.evaluateName

            if evaluate_name then
                eval.copy_expr(evaluate_name)
            else
                vim.notify("Missing `evaluateName`, can't copy variable")
            end
        else
            vim.notify("No expression or variable under the under cursor")
        end
    end
end

---@param value string
---@param line number
M.set_watch_expr = function(value, line)
    if not guard.expect_stopped() then
        return
    end

    local expression_view = state.expression_views_by_line[line]

    if expression_view then
        -- Top level expressions are responses for the `evaluate` request, they have no `evaluateName`
        -- Therefore, we can always use `setExpression` if the adapter supports it
        set.set_expr(expression_view.expression, value)
    else
        local variable_view = state.variable_views_by_line[line]

        if variable_view then
            local variable_name = variable_view.view.variable.name
            local evaluate_name = variable_view.view.variable.evaluateName

            local parent_reference = variable_view.parent_reference

            set.set_value(parent_reference, variable_name, value, evaluate_name)
        else
            vim.notify("No expression or variable under the under cursor")
        end
    end
end

---@param expr string
---@param line number
M.edit_watch_expr = function(expr, line)
    if #expr == 0 or not guard.expect_stopped() then
        return false
    end

    -- The easiest way to edit is to delete and insert again
    local expression_view = M.remove_watch_expr(line)

    if expression_view == nil then
        return false
    end

    eval.evaluate_expression(expr, expression_view.view.expanded)

    return true
end

---@param line number
M.expand_or_collapse = function(line)
    if not guard.expect_stopped() then
        return
    end

    local expression_view = state.expression_views_by_line[line]

    if expression_view then
        expression_view.view.expanded = not expression_view.view.expanded

        eval.evaluate_expression(expression_view.expression, true)

        return true
    else
        local variable_reference = state.variable_views_by_line[line]

        if variable_reference then
            local variable_view = variable_reference.view
            local reference = variable_view.variable.variablesReference

            if reference > 0 then
                variable_view.expanded = not variable_view.expanded

                variable_view.children, variable_view.err = eval.expand_variable(reference)

                return true
            else
                vim.notify("Nothing to expand")
            end
        else
            vim.notify("No expression or variable under the under cursor")
        end
    end
end

return M
