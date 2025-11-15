local M = {}

---@param name string
---@param value string
---@param variables_reference number
local set_var = function(name, value, variables_reference)
    local session = assert(require("dap").session(), "has active session")

    if session.capabilities.supportsSetVariable then
        coroutine.wrap(function()
            local err, _ =
                session:request("setVariable", { name = name, value = value, variablesReference = variables_reference })

            if err then
                vim.notify("Failed to set variable " .. name .. " to value " .. value)
            end
        end)()
    else
        vim.notify("Adapter doesn't support `setVariable` request")
    end
end

---@param expr string
---@param value string
M.set_expr = function(expr, value)
    local session = assert(require("dap").session(), "has active session")

    if session.capabilities.supportsSetExpression then
        coroutine.wrap(function()
            local frame_id = session.current_frame and session.current_frame.id

            local err, _ = session:request("setExpression", { expression = expr, value = value, frameId = frame_id })

            if err then
                vim.notify("Failed to set expression " .. expr .. " to value " .. value)
            end
        end)()
    else
        vim.notify("Adapter doesn't support `setExpression` request")
    end
end

---@param parent_reference integer
---@param variable_name string
---@param value string
---@param evaluate_name string?
M.set_value = function(parent_reference, variable_name, value, evaluate_name)
    -- From the protocol:
    --
    -- "If a debug adapter implements both `setExpression` and `setVariable`,
    -- a client uses `setExpression` if the variable has an evaluateName property."
    local session = assert(require("dap").session(), "has active session")
    local hasExpression = session.capabilities.supportsSetExpression
    local hasVariable = session.capabilities.supportsSetVariable

    -- To update the value of a variable, we don't look at its own `variablesReference`,
    -- as that's what's used to expand its children.
    --
    -- Instead, we have to use the `variablesReference` from the "parent" variable or expression,
    -- as that's what was used to actually request the variable

    if hasExpression and hasVariable then
        if evaluate_name then
            M.set_expr(evaluate_name, value)
        else
            set_var(variable_name, value, parent_reference)
        end
    elseif hasExpression then
        if evaluate_name then
            M.set_expr(evaluate_name, value)
        else
            return vim.notify("Can't set value for " .. variable_name .. " because it lacks an `evaluateName`")
        end
    elseif hasVariable then
        set_var(variable_name, value, parent_reference)
    else
        return vim.notify("Adapter lacks support for both `setExpression` and `setVariable` requests")
    end
end

return M
