local dap = require("dap")

local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")
local views = require("dap-view.views")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

M.show = function()
    winbar.update_section("exceptions")

    if state.bufnr then
        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

        if views.cleanup_view(not dap.session(), "No active session") then
            return
        end

        if
            views.cleanup_view(vim.tbl_isempty(state.exceptions_options), "Not supported by debug adapter")
        then
            return
        end

        local content = vim.iter(state.exceptions_options)
            :map(function(opt)
                local icon = opt.enabled and "" or ""
                return "  " .. icon .. "  " .. opt.exception_filter.label
            end)
            :totable()

        api.nvim_buf_set_lines(state.bufnr, 0, -1, false, content)

        for i, opt in ipairs(state.exceptions_options) do
            local hl_type = opt.enabled and "Enabled" or "Disabled"
            hl.hl_range("ExceptionFilter" .. hl_type, { i - 1, 0 }, { i - 1, 4 })
        end
    end
end

return M
