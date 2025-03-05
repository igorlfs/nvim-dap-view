local state = require("dap-view.state")
local guard = require("dap-view.guard")
local eval = require("dap-view.watches.eval")

local M = {}

---@param expr string
local is_expr_valid = function(expr)
    -- Avoid duplicate expressions
    return #expr > 0 and not vim.tbl_contains(state.watched_expressions, expr)
end

---@param expr string
---@return boolean
M.add_watch_expr = function(expr)
    if not is_expr_valid(expr) or not guard.expect_session() then
        return false
    end

    eval.eval_expr(expr, function(result)
        table.insert(state.expression_results, result)
    end)

    table.insert(state.watched_expressions, expr)

    return true
end

---@param line number
M.remove_watch_expr = function(line)
    table.remove(state.watched_expressions, line)
    table.remove(state.expression_results, line)
end

---@param expr string
---@param line number
M.edit_watch_expr = function(expr, line)
    if not is_expr_valid(expr) or not guard.expect_session() then
        return
    end

    state.watched_expressions[line] = expr

    eval.eval_expr(expr, function(result)
        state.expression_results[line] = result
    end)
end

return M
