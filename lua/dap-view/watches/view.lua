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
            local content = watch .. " = " .. expr.result or tostring(expr)

            api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { content })
            local hl_start = #watch + 3

            -- TODO perhaps we should try to match nvim-dap's widgets's style
            hl.hl_range("WatchText", { line, hl_start }, { line, -1 })

            -- TODO later we can assign a line to a given expression to simplify some operations
            line = line + 1
        end
    end
end

return M
