---@class ExceptionsOption
---@field exception_filter dap.ExceptionBreakpointsFilter
---@field enabled boolean

---@class ThreadWithErr: dap.Thread
---@field err? string

---@class ExpressionPack
---@field response? dap.EvaluateResponse | string
---@field children? VariablePack[] | string
---@field expanded boolean
---@field updated boolean

---@class VariablePack
---@field variable dap.Variable
---@field updated boolean
---@field reference number
---@field expanded boolean
---@field children string|VariablePack[]

-- Necessary for some type assertions
---@class VariablePackNested : VariablePack
---@field children VariablePack[]

---@class State
---@field bufnr? integer
---@field winnr? integer
---@field term_bufnr? integer
---@field term_winnr? integer
---@field last_active_adapter? string
---@field subtle_frames boolean
---@field current_section? SectionType
---@field exceptions_options ExceptionsOption[]
---@field threads ThreadWithErr[]
---@field threads_err? string
---@field frames_by_line table<integer, dap.StackFrame[]>
---@field expressions_by_line table<integer, {name: string, expression: ExpressionPack}>
---@field variables_by_line table<integer, {response: dap.Variable, reference: number}>
---@field watched_expressions table<string, ExpressionPack>
local M = {
    exceptions_options = {},
    threads = {},
    frames_by_line = {},
    expressions_by_line = {},
    variables_by_line = {},
    subtle_frames = false,
    watched_expressions = {},
}

return M
