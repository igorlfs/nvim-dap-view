---@class ExceptionsOption
---@field exception_filter dap.ExceptionBreakpointsFilter
---@field enabled boolean

---@class ThreadWithErr: dap.Thread
---@field err? string

---@class State
---@field bufnr? integer
---@field winnr? integer
---@field term_bufnr? integer
---@field term_winnr? integer
---@field last_active_adapter? string
---@field current_section? SectionType
---@field exceptions_options ExceptionsOption[]
---@field threads ThreadWithErr[]
---@field threads_err? string
---@field frames_by_line {[number]: dap.StackFrame[]}
---@field expressions_by_line {[integer]: string}
---@field variables_by_reference table<integer, {variable: dap.Variable, updated: boolean}[] | string>
---@field variables_by_line {[integer]: dap.Variable}
---@field subtle_frames boolean
---@field watched_expressions table<string,{response?: (dap.EvaluateResponse | string), updated?: boolean}>
local M = {
    exceptions_options = {},
    threads = {},
    frames_by_line = {},
    expressions_by_line = {},
    variables_by_reference = {},
    variables_by_line = {},
    subtle_frames = false,
    watched_expressions = {},
}

return M
