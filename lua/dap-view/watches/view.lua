local state = require("dap-view.state")
local winbar = require("dap-view.options.winbar")
local views = require("dap-view.views")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

M.show = function()
    winbar.update_winbar("watches")

    if state.bufnr then
        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

        if views.cleanup_view(#state.watched_expressions == 0, "No expressions") then
            return
        end

        local line = 0
        for i, expr in pairs(state.expression_results) do
            local watch = state.watched_expressions[i]
            local value = expr.result and expr.result or tostring(expr)
            local content = watch .. " = " .. value

            api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { content })

            hl.hl_range("WatchExpr", { line, 0 }, { line, #watch })

            local hl_start = #watch + 3

            -- TODO perhaps we should try to match nvim-dap's widgets's style
            hl.hl_range("WatchValue", { line, hl_start }, { line, -1 })

            -- TODO later we can assign a line to a given expression to simplify some operations
            line = line + 1

            if expr.result then
                local variables = state.variables_by_reference[expr.variablesReference]
                for _, var in ipairs(variables or {}) do
                    local _value = #var.value > 0 and var.value or var.variablesReference > 0 and "..." or ""
                    local var_content = "\t" .. var.name .. " = " .. _value
                    api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { var_content })

                    hl.hl_range("WatchExpr", { line, 1 }, { line, 1 + #var.name })

                    line = line + 1
                end
            end
        end
    end
end

return M
