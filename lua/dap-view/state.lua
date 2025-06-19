---@class dapview.ExceptionsOption
---@field exception_filter dap.ExceptionBreakpointsFilter
---@field enabled boolean

---@class dapview.ThreadWithErr: dap.Thread
---@field err? string

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
---@field term_bufnr? integer
---@field term_winnr? integer
---@field last_active_adapter? string
---@field subtle_frames boolean
---@field current_section? dapview.SectionType
---@field exceptions_options dapview.ExceptionsOption[]
---@field threads dapview.ThreadWithErr[]
---@field threads_err? string
---@field frames_by_line table<integer, dap.StackFrame>
---@field expressions_by_line table<integer, {name: string, expression: dapview.ExpressionPack}>
---@field variables_by_line table<integer, {response: dap.Variable, reference: number}>
---@field watched_expressions table<string, dapview.ExpressionPack>
---@field cur_pos table<dapview.SectionType,integer?>
local M = {
    exceptions_options = {},
    threads = {},
    frames_by_line = {},
    expressions_by_line = {},
    variables_by_line = {},
    subtle_frames = false,
    watched_expressions = {},
    cur_pos = {},
}

return M
