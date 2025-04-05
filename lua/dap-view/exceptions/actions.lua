local exceptions = require("dap-view.exceptions")
local state = require("dap-view.state")
local hl = require("dap-view.util.hl")
local util = require("dap-view.util")

local M = {}

local api = vim.api

M.toggle_exception_filter = function()
    local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

    local current_option = state.exceptions_options[cursor_line]

    current_option.enabled = not current_option.enabled

    local icon = current_option.enabled and "" or ""

    local content = "  " .. icon .. "  " .. current_option.exception_filter.label
    if util.is_buf_valid(state.bufnr) then
      api.nvim_buf_set_lines(state.bufnr, cursor_line - 1, cursor_line, false, { content })
    end

    local hl_type = current_option.enabled and "Enabled" or "Disabled"
    hl.hl_range("ExceptionFilter" .. hl_type, { cursor_line - 1, 0 }, { cursor_line - 1, 4 })

    exceptions.update_exception_breakpoints_filters()
end

return M
