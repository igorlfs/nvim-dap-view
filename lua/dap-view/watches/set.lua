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

---@param name string
---@param value string
---@param variables_reference number
M.set_var = function(name, value, variables_reference)
    local session = assert(require("dap").session(), "has active session")

    if session.capabilities.supportsSetVariable then
        coroutine.wrap(function()
            local err, _ = session:request(
                "setVariable",
                { name = name, value = value, variablesReference = variables_reference }
            )

            if err then
                vim.notify("Failed to set variable " .. name .. " to value " .. value)
            end
        end)()
    else
        vim.notify("Adapter doesn't support `setVariable` request")
    end
end

return M
