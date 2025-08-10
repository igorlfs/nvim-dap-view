local dap = require("dap")

local state = require("dap-view.state")
local views = require("dap-view.views")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")
local setup = require("dap-view.setup")

local M = {}

local api = vim.api

M.show = function()
    -- We have to check if the win is valid, since this function may be triggered by an event when the window is closed
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        if views.cleanup_view(not dap.session(), "No active session") then
            return
        end

        local adapter_exception_options = state.exceptions_options[state.current_adapter] or {}
        if views.cleanup_view(vim.tbl_isempty(adapter_exception_options), "Not supported by debug adapter") then
            return
        end

        local content = vim.iter(adapter_exception_options)
            :map(function(opt)
                local icon = opt.enabled and setup.config.icons["enabled"] or setup.config.icons["disabled"]
                return "  " .. icon .. "  " .. opt.exception_filter.label
            end)
            :totable()

        api.nvim_buf_set_lines(state.bufnr, 0, -1, false, content)

        for i, opt in ipairs(adapter_exception_options) do
            local hl_type = opt.enabled and "Enabled" or "Disabled"
            hl.hl_range("ExceptionFilter" .. hl_type, { i - 1, 0 }, { i - 1, 4 })
        end
    end
end

return M
