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
---@field stopped_thread? integer
---@field last_active_adapter? string
---@field current_section? SectionType
---@field exceptions_options ExceptionsOption[]
---@field threads ThreadWithErr[]
---@field threads_err? string
---@field frames_by_line {[number]: dap.StackFrame[]}
---@field subtle_frames boolean
---@field watched_expressions string[]
---@field expression_results string[]
---@field updated_evaluations boolean[]
---@field cursor_pos [integer, integer]
local M = {
    exceptions_options = {},
    threads = {},
    frames_by_line = {},
    subtle_frames = false,
    watched_expressions = {},
    expression_results = {},
    updated_evaluations = {},
    cursor_pos = { 1, 0 },
}

return M
