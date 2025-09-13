---@class dapview.ExceptionsOption
---@field exception_filter dap.ExceptionBreakpointsFilter
---@field enabled boolean

---@class dapview.VariableView
---@field variable dap.Variable
---@field err? dap.ErrorResponse
---@field updated boolean
---@field reference number
---@field expanded boolean
---@field children? dapview.VariableView[]

---@class dapview.ExpressionView
---@field id integer
---@field response? dap.EvaluateResponse
---@field err? dap.ErrorResponse
---@field children? dapview.VariableView[]
---@field expanded boolean
---@field updated boolean

---@class dapview.State
---@field bufnr? integer
---@field winnr? integer
---@field term_winnr? integer
---@field last_term_winnr? integer
---@field threads_filter string
---@field threads_filter_invert boolean
---@field current_adapter? string
---@field subtle_frames boolean
---@field current_section? dapview.Section
---@field current_session_id? number
---@field exceptions_options table<string,dapview.ExceptionsOption[]>
---@field stack_trace_errors string[]
---@field threads_error? string
---@field frames_by_line table<integer, dap.StackFrame>
---@field expression_views_by_line table<integer, {expression: string, view: dapview.ExpressionView}>
---@field variable_views_by_line table<integer, {parent_reference: number, variable: dap.Variable, view: dapview.VariableView}>
---@field watched_expressions table<string, dapview.ExpressionView>
---@field expr_count integer
---@field cur_pos table<dapview.DefaultSection,integer?>
local M = {
    expr_count = 0,
    threads_filter = "",
    threads_filter_invert = false,
    exceptions_options = {},
    stack_trace_errors = {},
    frames_by_line = {},
    expression_views_by_line = {},
    variable_views_by_line = {},
    subtle_frames = false,
    watched_expressions = {},
    cur_pos = {},
}

return M
