---@class ExceptionsOption
---@field exception_filter dap.ExceptionBreakpointsFilter
---@field enabled boolean

---@class State
---@field bufnr? integer
---@field winnr? integer
---@field last_active_adapter? string
---@field current_section? SectionType
---@field exceptions_options? ExceptionsOption[]
---@field watched_expressions string[]
---@field expression_results string[]
---@field updated_evaluations boolean[]
local M = {
    watched_expressions = {},
    expression_results = {},
    updated_evaluations = {},
}

return M
