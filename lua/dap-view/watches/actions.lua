local state = require("dap-view.state")
local guard = require("dap-view.guard")
local eval = require("dap-view.watches.eval")

local M = {}

---@param expr string
local is_expr_valid = function(expr)
    -- Avoid duplicate expressions
    return #expr > 0 and state.watched_expressions[expr] == nil
end

---@param expr string
---@return boolean
M.add_watch_expr = function(expr)
    if not is_expr_valid(expr) or not guard.expect_session() then
        return false
    end

    eval.eval_expr(expr)

    return true
end

---@param line number
M.remove_watch_expr = function(line)
    local expr = state.expressions_by_line[line]
    if expr then
        local eval_result = state.watched_expressions[expr].response

        state.watched_expressions[expr] = nil
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
        eval.copy_expr(expr)
    else
        vim.notify("No expression under the under cursor")
    end
end

---@param expr string
---@param line number
M.edit_watch_expr = function(expr, line)
    if not is_expr_valid(expr) or not guard.expect_session() then
        return
    end

    -- The easiest way to edit is to delete and insert again
    M.remove_watch_expr(line)

    eval.eval_expr(expr)
end

return M
