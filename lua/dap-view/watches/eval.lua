local M = {}

---@param expr string
---@param callback fun(result: string): nil
M.eval_expr = function(expr, callback)
    local session = assert(require("dap").session(), "has active session")

    coroutine.wrap(function()
        local frame_id = session.current_frame and session.current_frame.id

        local err, result =
            session:request("evaluate", { expression = expr, context = "watch", frameId = frame_id })

        local expr_result = result and result.result or err and tostring(err):gsub("%s+", " ") or ""

        -- TODO currently, we only check for variables reference for the top level expression
        -- It would be nice to expose functionality to let the user control the depth
        -- This could be a config parameter (eg, base depth) but could also extend with an action (BFS)
        local var_ref = result and result.variablesReference
        if var_ref and var_ref > 0 then
            local enhanced_expr_result = { expr_result }

            local var_ref_err, var_ref_result = session:request(
                "variables",
                { variablesReference = var_ref, context = "watch", frameId = frame_id }
            )

            if var_ref_err then
                table.insert(enhanced_expr_result, tostring(err))
            end

            if var_ref_result and not var_ref_err then
                for _, k in pairs(var_ref_result.variables) do
                    table.insert(enhanced_expr_result, "\t" .. k.name .. " = " .. k.value)
                end
            end

            local final_result = table.concat(enhanced_expr_result, "\n")

            callback(final_result)
        else
            callback(expr_result)
        end
    end)()
end

return M
