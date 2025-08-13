---@class dapview.ExceptionsOption
---@field exception_filter dap.ExceptionBreakpointsFilter
---@field enabled boolean

---@class dapview.VariablePack
---@field variable dap.Variable
---@field updated boolean
---@field reference number
---@field expanded boolean
---@field children string|dapview.VariablePack[]

-- Necessary for some type assertions
---@class dapview.VariablePackStrict : dapview.VariablePack
---@field children dapview.VariablePack[]

---@class dapview.ExpressionPack
---@field response? dap.EvaluateResponse | string
---@field children? dapview.VariablePack[] | string
---@field expanded boolean
---@field updated boolean

---@class dapview.State
---@field bufnr? integer
---@field winnr? integer
---@field term_bufnrs {[number]: number}
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
---@field expressions_by_line table<integer, {name: string, expression: dapview.ExpressionPack}>
---@field variables_by_line table<integer, {response: dap.Variable, reference: number}>
---@field watched_expressions table<string, dapview.ExpressionPack>
---@field cur_pos table<dapview.DefaultSection,integer?>
local M = {
    term_bufnrs = {},
    threads_filter = "",
    threads_filter_invert = false,
    exceptions_options = {},
    stack_trace_errors = {},
    frames_by_line = {},
    expressions_by_line = {},
    variables_by_line = {},
    subtle_frames = false,
    watched_expressions = {},
    cur_pos = {},
}

return M
