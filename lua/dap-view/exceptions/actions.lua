local exceptions = require("dap-view.exceptions")
local state = require("dap-view.state")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

M._toggle_exception_filter = function()
    local cur_row = api.nvim_win_get_cursor(state.winnr)[1]

    local curent_option = state.exceptions_options[cur_row]

    curent_option.enabled = not curent_option.enabled

    local icon = curent_option.enabled and "" or ""

    local content = "  " .. icon .. "  " .. curent_option.exception_filter.label

    api.nvim_buf_set_lines(state.bufnr, cur_row - 1, cur_row, false, { content })

    local hl_type = curent_option.enabled and "Enabled" or "Disabled"
    hl.hl_range("ExceptionFilter" .. hl_type, { cur_row - 1, 0 }, { cur_row - 1, 4 })

    exceptions.update_exception_breakpoints_filters()
end

return M
