local state = require("dap-view.state")

local M = {}

---@param expr_name string
---@param callback? fun(): nil
M.eval_expr = function(expr_name, callback)
    local session = assert(require("dap").session(), "has active session")

    coroutine.wrap(function()
        local frame_id = session.current_frame and session.current_frame.id

        local err, result =
            session:request("evaluate", { expression = expr_name, context = "watch", frameId = frame_id })

        local previous_expr = state.watched_expressions[expr_name]

        local previous_result = previous_expr and previous_expr.response and previous_expr.response.result
        if previous_expr and result then
            previous_expr.updated = previous_result ~= result.result
        end

        if err and previous_expr then
            previous_expr.children = nil
        end

        local response = err and tostring(err) or result

        ---@type dapview.ExpressionPack
        local new_expr
        if previous_expr then
            previous_expr.response = response
            new_expr = previous_expr
        else
            new_expr = { response = response, updated = false, expanded = true, children = nil }
        end

        local variables_reference
        if new_expr and type(new_expr.response) == "table" then
            variables_reference = new_expr.response.variablesReference
        end

        local is_expanded = previous_expr and previous_expr.expanded or not previous_expr

        if is_expanded and variables_reference and variables_reference > 0 then
            M.expand_var(variables_reference, new_expr.children, function(children)
                new_expr.children = children

                state.watched_expressions[expr_name] = new_expr

                if callback then
                    callback()
                end
            end)
        else
            state.watched_expressions[expr_name] = new_expr

            if callback then
                callback()
            end
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
                -- TODO uses system clipboard, could be a parameter instead
                vim.fn.setreg("+", result.result)

                vim.notify("Variable " .. expr .. " copied to clipboard")
            end
        end)()
    else
        vim.notify("Adapter doesn't support clipboard evaluation")
    end
end

---@param variables_reference number
---@param original (dapview.VariablePack[] | string)?
---@param callback fun(result: dapview.VariablePack[] | string): nil
function M.expand_var(variables_reference, original, callback)
    local session = assert(require("dap").session(), "has active session")

    local frame_id = session.current_frame and session.current_frame.id

    session:request(
        "variables",
        { variablesReference = variables_reference, context = "watch", frameId = frame_id },
        -- HACK Using a callback was the only way I could make this work
        function(err, result)
            local response = nil
            if err then
                response = tostring(err)
            end
            if result then
                response = result.variables
            end

            ---@type dapview.VariablePack[] | string
            local variables = type(response) == "string" and response or {}

            if type(variables) ~= "string" and type(response) ~= "string" then
                for k, var in pairs(response or {}) do
                    ---@type dapview.VariablePack?
                    local previous

                    if type(original) ~= "string" then
                        ---@type dapview.VariablePack?
                        previous = vim.iter(original or {}):find(
                            ---@param v dapview.VariablePack
                            function(v)
                                if v.variable.evaluateName then
                                    return v.variable.evaluateName == var.evaluateName
                                end
                                if v.variable.variablesReference > 0 then
                                    return v.variable.variablesReference == var.variablesReference
                                end
                            end
                        )
                        if err and previous then
                            previous.children = nil
                            previous.expanded = false
                            previous.updated = false
                        end
                    end

                    if previous and not err then
                        previous.updated = previous.variable.value ~= var.value

                        previous.variable = var
                    end

                    local default_var = { variable = var, updated = false, expanded = false, children = nil }

                    local new_var = previous or default_var

                    if previous and previous.expanded and previous.variable.variablesReference > 0 then
                        M.expand_var(
                            previous.variable.variablesReference,
                            new_var.children,
                            function(children)
                                new_var.children = children

                                variables[k] = new_var
                            end
                        )
                    else
                        variables[k] = new_var
                    end
                end
            end

            callback(variables)
        end
    )
end

M.reeval = function()
    for expr, _ in pairs(state.watched_expressions) do
        M.eval_expr(expr)
    end

    if state.current_section == "watches" then
        require("dap-view.views").switch_to_view("watches")
    end
end

return M
