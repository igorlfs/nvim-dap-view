local state = require("dap-view.state")

local M = {}

---@param expression string
---@param default_expanded boolean
---@param co thread?
M.evaluate_expression = function(expression, default_expanded, co)
    local session = assert(require("dap").session(), "has active session")

    coroutine.wrap(function()
        local frame_id = session.current_frame and session.current_frame.id

        local err, response =
            session:request("evaluate", { expression = expression, context = "watch", frameId = frame_id })

        local previous_expression_view = state.watched_expressions[expression]

        local previous_result = previous_expression_view
            and previous_expression_view.response
            and previous_expression_view.response.result

        if previous_expression_view and response then
            previous_expression_view.updated = previous_result ~= response.result
        end

        if previous_expression_view and err then
            previous_expression_view.children = nil
            previous_expression_view.updated = false
            previous_expression_view.expanded = false
        end

        ---@type dapview.ExpressionView
        local default_expression_view = {
            id = state.expr_count,
            response = response,
            err = err,
            updated = false,
            expanded = default_expanded,
            children = nil,
        }

        if previous_expression_view then
            previous_expression_view.response = response
            previous_expression_view.err = err
        end

        ---@type dapview.ExpressionView
        local new_expression_view = previous_expression_view or default_expression_view

        if new_expression_view.expanded then
            local variables_reference = response and response.variablesReference

            if variables_reference and variables_reference > 0 then
                new_expression_view.children = M.expand_variable(variables_reference, new_expression_view.children)
            else
                new_expression_view.children = nil
            end
        end

        state.watched_expressions[expression] = new_expression_view

        if co then
            coroutine.resume(co)
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
---@param previous_expansion_result dapview.VariableView[]?
M.expand_variable = function(variables_reference, previous_expansion_result)
    local session = assert(require("dap").session(), "has active session")

    local frame_id = session.current_frame and session.current_frame.id

    local err, response = session:request(
        "variables",
        { variablesReference = variables_reference, context = "watch", frameId = frame_id }
    )

    local response_variables = response and response.variables

    ---@type dapview.VariableView[]
    local varible_views = {}

    for k, variable in ipairs(response_variables or {}) do
        ---@type dapview.VariableView?
        local previous_variable_view = vim.iter(previous_expansion_result or {}):find(
            ---@param v dapview.VariableView
            function(v)
                if v.variable.evaluateName then
                    return v.variable.evaluateName == variable.evaluateName
                end
                if v.variable.variablesReference > 0 then
                    return v.variable.variablesReference == variable.variablesReference
                end
            end
        )

        if previous_variable_view then
            if err then
                previous_variable_view.children = nil
                previous_variable_view.expanded = false
                previous_variable_view.updated = false
            else
                previous_variable_view.updated = previous_variable_view.variable.value ~= variable.value

                previous_variable_view.variable = variable
            end
        end

        ---@type dapview.VariableView
        local default_variable_view = {
            variable = variable,
            updated = false,
            expanded = false,
            children = nil,
            reference = variable.variablesReference,
        }

        ---@type dapview.VariableView
        local new_variable_view = previous_variable_view or default_variable_view

        local variables_reference_ = variable.variablesReference

        if new_variable_view.expanded then
            if variables_reference_ > 0 then
                new_variable_view.children, new_variable_view.err =
                    M.expand_variable(variables_reference_, new_variable_view.children)
            else
                -- We have to reset the children if the variable is no longer, otherwise it retains the old value indefinely
                new_variable_view.children = nil
            end
        end

        varible_views[k] = new_variable_view
    end

    return #varible_views > 0 and varible_views or nil, err
end

---@param co thread?
M.reevaluate_all_expressions = function(co)
    local i = 0
    local size = vim.tbl_count(state.watched_expressions)

    for expr, _ in pairs(state.watched_expressions) do
        i = i + 1

        -- This assumes that the last evaluation will be the last one to fnish, but I'm not sure that's the case?
        M.evaluate_expression(expr, true, i == size and co or nil)
    end

    coroutine.yield(co)
end

return M
