local state = require("dap-view.state")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

M.toggle_exception_filter = function()
    local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

    local current_option = state.exceptions_options[state.current_adapter][cursor_line]

    current_option.enabled = not current_option.enabled

    local icon = current_option.enabled and "" or ""

    local content = "  " .. icon .. "  " .. current_option.exception_filter.label

    api.nvim_buf_set_lines(state.bufnr, cursor_line - 1, cursor_line, false, { content })

    local hl_type = current_option.enabled and "Enabled" or "Disabled"
    hl.hl_range("ExceptionFilter" .. hl_type, { cursor_line - 1, 0 }, { cursor_line - 1, 4 })

    require("dap-view.exceptions").update_exception_breakpoints_filters()
end

return M
