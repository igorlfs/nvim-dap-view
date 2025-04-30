local state = require("dap-view.state")

local M = {}

---@param variables_reference number
---@param frame_id? number
local eval_variables = function(variables_reference, frame_id)
    local session = assert(require("dap").session(), "has active session")

    local err, result = session:request(
        "variables",
        { variablesReference = variables_reference, context = "watch", frameId = frame_id }
    )

    local response = err and tostring(err) or result and result.variables

    --[[@type {variable?: dap.Variable, updated?: boolean}[] | string]]
    local variables = type(response) == "string" and response or {}

    local original = state.variables_by_reference[variables_reference]

    -- Lua's type checking is a lackluster
    if type(variables) ~= "string" and type(response) ~= "string" then
        for k, var in pairs(response or {}) do
            local updated = type(original) == "table" and original[k].variable.value ~= var.value or false
            table.insert(variables, { variable = var, updated = updated })
        end
    end

    state.variables_by_reference[variables_reference] = variables
end

---@param expr string
M.eval_expr = function(expr)
    local session = assert(require("dap").session(), "has active session")

    coroutine.wrap(function()
        local frame_id = session.current_frame and session.current_frame.id

        local err, result =
            session:request("evaluate", { expression = expr, context = "watch", frameId = frame_id })

        local stored_expr = state.watched_expressions[expr]
        local original = stored_expr and (stored_expr.response.result or stored_expr.response.value)
        local response = err and tostring(err) or result
        local updated = original and response and original ~= response.result
        state.watched_expressions[expr] = { response = response, updated = updated }

        local variables_reference = result and result.variablesReference
        if variables_reference and variables_reference > 0 then
            eval_variables(variables_reference, frame_id)
        end
    end)()
end

---@param expr string
M.copy_expr = function(expr)
    local session = assert(require("dap").session(), "has active session")

    if session.capabilities.supportsClipboardContext then
        coroutine.wrap(function()
            local frame_id = session.current_frame and session.current_frame.id

            local err, result =
                session:request("evaluate", { expression = expr, context = "clipboard", frameId = frame_id })

            if err == nil and result then
                -- TODO uses system clipboard, could be a parameter instead (fzf handles this nicely)
                vim.fn.setreg("+", result.result)
            end
        end)()
    else
        vim.notify("Adapter doesn't support clipboard evaluation")
    end
end

return M
