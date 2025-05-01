local state = require("dap-view.state")
local guard = require("dap-view.guard")
local eval = require("dap-view.watches.eval")
local set = require("dap-view.watches.set")

local M = {}

---@param expr string
---@return boolean
M.add_watch_expr = function(expr)
    if #expr == 0 or not guard.expect_session() then
        return false
    end

    eval.eval_expr(expr)

    return true
end

---@param line number
M.remove_watch_expr = function(line)
    local expr = state.expressions_by_line[line]
    if expr then
        local eval_result = state.watched_expressions[expr.name].response

        state.watched_expressions[expr.name] = nil
        state.expressions_by_line[line] = nil

        -- If the result is a string, it's the error
        if type(eval_result) ~= "string" then
            local ref = eval_result and eval_result.variablesReference
            if ref then
                state.variables_by_reference[ref] = nil
            end
        end
    else
        vim.notify("No expression under the under cursor")
    end
end

---@param line number
M.copy_watch_expr = function(line)
    local expr = state.expressions_by_line[line]
    if expr then
        eval.copy_expr(expr.name)
    else
        local var = state.variables_by_line[line]
        if var then
            if var.response.evaluateName then
                eval.copy_expr(var.response.evaluateName)
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

    local expr = state.expressions_by_line[line]
    if expr then
        -- Top level expressions are responses for the `evaluate` request, they have no `evaluateName`
        -- Therefore, we can always use `setExpression` if the adapter supports it
        set.set_expr(expr.name, value)
    else
        local var = state.variables_by_line[line]

        if var then
            -- From the protocol:
            --
            -- "If a debug adapter implements both `setExpression` and `setVariable`,
            -- a client uses `setExpression` if the variable has an evaluateName property."
            local session = assert(require("dap").session(), "has active session")
            local hasExpression = session.capabilities.supportsSetExpression
            local hasVariable = session.capabilities.supportsSetVariable

            if hasExpression and hasVariable then
                if var.response.evaluateName then
                    set.set_expr(var.response.evaluateName, value)
                else
                    set.set_var(var.response.name, value, var.reference)
                end
            elseif hasExpression then
                if var.response.evaluateName then
                    set.set_expr(var.response.evaluateName, value)
                else
                    vim.notify(
                        "Can't set value for " .. var.response.name .. " because it lacks an `evaluateName`"
                    )
                end
            elseif hasVariable then
                set.set_var(var.response.name, value, var.reference)
            else
                vim.notify("Adapter lacks support for both `setExpression` and `setVariable` requests")
            end
        else
            vim.notify("No expression or variable under the under cursor")
        end
    end
end

---@param expr string
---@param line number
M.edit_watch_expr = function(expr, line)
    if #expr == 0 or not guard.expect_session() then
        return
    end

    -- The easiest way to edit is to delete and insert again
    M.remove_watch_expr(line)

    eval.eval_expr(expr)
end

return M
