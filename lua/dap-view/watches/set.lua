local M = {}

---@param expr string
---@param value string
M.set_expr = function(expr, value)
    local session = assert(require("dap").session(), "has active session")

    if session.capabilities.supportsSetExpression then
        coroutine.wrap(function()
            local frame_id = session.current_frame and session.current_frame.id

            local err, _ =
                session:request("setExpression", { expression = expr, value = value, frameId = frame_id })

            if err then
                vim.notify("Failed to set expression " .. expr .. " to value " .. value)
            end
        end)()
    else
        vim.notify("Adapter doesn't support `setExpression` request")
    end
end

---@param expr string
---@param value string
M.set_var_expr = function(expr, value)
    local session = assert(require("dap").session(), "has active session")

    if session.capabilities.supportsSetExpression then
        coroutine.wrap(function()
            local frame_id = session.current_frame and session.current_frame.id

            local err, _ =
                session:request("setExpression", { expression = expr, value = value, frameId = frame_id })

            if err then
                vim.notify("Failed to set expression " .. expr .. " to value " .. value)
            end
        end)()
    else
        vim.notify("Adapter doesn't support `setExpression` request")
    end
end

return M
