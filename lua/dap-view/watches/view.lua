local state = require("dap-view.state")
local winbar = require("dap-view.options.winbar")
local globals = require("dap-view.globals")
local views = require("dap-view.views")
local util_string = require("dap-view.util.string")
local util = require("dap-view.util")

local M = {}

local api = vim.api

M.show = function()
    winbar.update_winbar("watches")

    if util.is_buf_valid(state.bufnr) then
        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

        if views.cleanup_view(#state.watched_expressions == 0, "No expressions") then
            return
        end

        api.nvim_buf_set_lines(
            state.bufnr,
            0,
            #state.watched_expressions + 1,
            false,
            state.watched_expressions
        )

        for i = 1, #state.watched_expressions do
            local hl_group = state.updated_evaluations[i] and "NvimDapViewWatchTextChanged"
                or "NvimDapViewWatchText"
            local expr_result = state.expression_results[i]

            if expr_result then
                local split_lines = util_string.split_string_to_table(expr_result)
                local virt_lines = vim.iter(split_lines)
                    :map(function(r)
                        return { { r, hl_group } }
                    end)
                    :totable()

                api.nvim_buf_set_extmark(state.bufnr, globals.NAMESPACE, i - 1, 0, {
                    virt_lines = virt_lines,
                    virt_lines_overflow = "scroll",
                })
            end
        end
    end
end

return M
