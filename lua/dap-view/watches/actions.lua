local state = require("dap-view.state")
local guard = require("dap-view.guard")
local eval = require("dap-view.watches.eval")
local set = require("dap-view.watches.set")

local M = {}

---@param expr string
---@param default_expanded boolean
---@param co thread
M.add_watch_expr = function(expr, default_expanded, co)
    if #expr == 0 or not guard.expect_session() then
        return false
    end

    eval.evaluate_expression(expr, default_expanded, co)

    coroutine.yield(co)

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
            local evaluate_name = variable_reference.variable.evaluateName

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
    if not guard.expect_session() then
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
            -- From the protocol:
            --
            -- "If a debug adapter implements both `setExpression` and `setVariable`,
            -- a client uses `setExpression` if the variable has an evaluateName property."
            local session = assert(require("dap").session(), "has active session")
            local hasExpression = session.capabilities.supportsSetExpression
            local hasVariable = session.capabilities.supportsSetVariable

            local variable_name = variable_view.variable.name
            local evaluate_name = variable_view.variable.evaluateName

            -- To update the value of a variable, we don't look at its own `variablesReference`,
            -- as that's what's used to expand its children.
            --
            -- Instead, we have to use the `variablesReference` from the "parent" variable or expression,
            -- as that's what was used to actually request the variable
            local variable_view_reference = variable_view.parent_reference

            if hasExpression and hasVariable then
                if evaluate_name then
                    set.set_expr(evaluate_name, value)
                else
                    set.set_var(variable_name, value, variable_view_reference)
                end
            elseif hasExpression then
                if evaluate_name then
                    set.set_expr(evaluate_name, value)
                else
                    return vim.notify("Can't set value for " .. variable_name .. " because it lacks an `evaluateName`")
                end
            elseif hasVariable then
                set.set_var(variable_name, value, variable_view_reference)
            else
                return vim.notify("Adapter lacks support for both `setExpression` and `setVariable` requests")
            end
        else
            vim.notify("No expression or variable under the under cursor")
        end
    end
end

---@param expr string
---@param line number
---@param co thread
M.edit_watch_expr = function(expr, line, co)
    if #expr == 0 or not guard.expect_session() then
        return false
    end

    -- The easiest way to edit is to delete and insert again
    local expression_view = M.remove_watch_expr(line)

    if expression_view == nil then
        return false
    end

    eval.evaluate_expression(expr, expression_view.view.expanded, co)

    coroutine.yield(co)

    return true
end

---@param line number
---@param co thread
M.expand_or_collapse = function(line, co)
    if not guard.expect_session() then
        return
    end

    local expression_view = state.expression_views_by_line[line]

    if expression_view then
        expression_view.view.expanded = not expression_view.view.expanded

        eval.evaluate_expression(expression_view.expression, true, co)

        coroutine.yield(co)

        return true
    else
        local variable_reference = state.variable_views_by_line[line]

        if variable_reference then
            local reference = variable_reference.variable.variablesReference

            if reference > 0 then
                local variable_view = variable_reference.view

                if variable_view then
                    variable_view.expanded = not variable_view.expanded

                    variable_view.children, variable_view.err = eval.expand_variable(reference, nil, co)

                    return true
                end
            else
                vim.notify("Nothing to expand")
            end
        else
            vim.notify("No expression or variable under the under cursor")
        end
    end
end

return M
