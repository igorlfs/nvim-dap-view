local state = require("dap-view.state")
local eval = require("dap-view.watches.eval")

local M = {}

---@param expr string
---@param value string
M.set_expr = function(expr, value)
    local session = assert(require("dap").session(), "has active session")

    if session.capabilities.supportsSetExpression then
        coroutine.wrap(function()
            local frame_id = session.current_frame and session.current_frame.id

            local err, result =
                session:request("setExpression", { expression = expr, value = value, frameId = frame_id })

            if err ~= nil then
                vim.notify("Failed to set expression " .. expr .. " to value " .. value)
            end

            local stored_expr = state.watched_expressions[expr]
            local original = nil
            if stored_expr then
                original = stored_expr.response.result or stored_expr.response.value
            end
            local response = err and tostring(err) or result
            local updated = original and response and original ~= response.value

            state.watched_expressions[expr] = { response = response, updated = updated }
        end)()
    else
        vim.notify("Adapter doesn't support `setExpression` request")
    end
end

---@param expr string
---@param value string
---@param parent string
M.set_var_expr = function(expr, value, parent)
    local session = assert(require("dap").session(), "has active session")

    if session.capabilities.supportsSetExpression then
        coroutine.wrap(function()
            local frame_id = session.current_frame and session.current_frame.id

            local err, result =
                session:request("setExpression", { expression = expr, value = value, frameId = frame_id })

            if err then
                vim.notify("Failed to set expression " .. expr .. " to value " .. value)
            elseif result then
                -- HACK Need to reeval here, otherwise change doesn't get redrawn until next stop
                eval.eval_expr(parent)
            end
        end)()
    else
        vim.notify("Adapter doesn't support `setExpression` request")
    end
end

return M
