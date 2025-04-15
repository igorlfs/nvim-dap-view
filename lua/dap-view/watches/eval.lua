local state = require("dap-view.state")

local M = {}

---@param expr string
---@param callback fun(result: string): nil
M.eval_expr = function(expr, callback)
    local session = assert(require("dap").session(), "has active session")

    coroutine.wrap(function()
        local frame_id = session.current_frame and session.current_frame.id

        local err, result =
            session:request("evaluate", { expression = expr, context = "watch", frameId = frame_id })

        table.insert(state.expression_results, err or result)

        local variables_reference = result and result.variablesReference
        -- if variables_reference and variables_reference > 0 then
        --
        --     local var_ref_err, var_ref_result = session:request(
        --         "variables",
        --         { variablesReference = variables_reference, context = "watch", frameId = frame_id }
        --     )
        --
        --     table.insert(state.watched_expressions.)
        --
        --     if var_ref_err then
        --         table.insert(enhanced_expr_result, tostring(err))
        --     elseif var_ref_result then
        --         for _, k in pairs(var_ref_result.variables) do
        --             table.insert(enhanced_expr_result, "\t" .. k.name .. " = " .. k.value)
        --         end
        --     end
        --
        --     local final_result = table.concat(enhanced_expr_result, "\n")
        --
        --     -- callback(final_result)
        -- else
        --     -- callback(expr_result)
        -- end
    end)()
end

return M
