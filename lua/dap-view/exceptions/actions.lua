local state = require("dap-view.state")
local hl = require("dap-view.util.hl")
local setup = require("dap-view.setup")
local util = require("dap-view.util")

local M = {}

---@param line integer
M.toggle_exception_filter = function(line)
    local current_option = state.exceptions_options[state.current_adapter][line]

    current_option.enabled = not current_option.enabled

    local icon = current_option.enabled and setup.config.icons["enabled"] or setup.config.icons["disabled"]

    local content = "  " .. icon .. "  " .. current_option.exception_filter.label

    util.set_lines(state.bufnr, line - 1, line, false, { content })

    local hl_type = current_option.enabled and "Enabled" or "Disabled"
    hl.hl_range("ExceptionFilter" .. hl_type, { line - 1, 0 }, { line - 1, 4 })

    require("dap-view.exceptions").update_exception_breakpoints_filters()
end

return M
