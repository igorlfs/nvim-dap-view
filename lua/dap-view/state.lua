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
---@field last_session_buf? integer
---@field exceptions_options table<string,dapview.ExceptionsOption[]>
---@field stack_trace_errors string[]
---@field threads_error? string
---@field frames_by_line table<integer, dap.StackFrame>
---@field frame_paths_by_frame_id table<integer, string>
---@field frame_line_by_frame_id table<integer, integer>
---@field breakpoint_paths_by_line string[]
---@field breakpoint_lines_by_line integer[]
---@field expression_views_by_line table<integer, {expression: string, view: dapview.ExpressionView}>
---@field variable_views_by_line table<integer, {parent_reference: number, view: dapview.VariableView}>
---@field sessions_by_line table<integer, dap.Session>
---@field variable_path_to_name table<string,string>
---@field variable_path_to_evaluate_name table<string,string>
---@field variable_path_to_value table<string,string>
---@field variable_path_is_expanded table<string,boolean>
---@field variable_path_to_parent_reference table<string,integer>
---@field line_to_variable_path table<integer,string>
---@field watched_expressions table<string, dapview.ExpressionView>
---@field expr_count integer
---@field cur_pos table<dapview.DefaultSection,[integer, integer]?>
---@field win_pos? dapview.Position
local M = {
    expr_count = 0,
    threads_filter = "",
    threads_filter_invert = false,
    exceptions_options = {},
    stack_trace_errors = {},
    frames_by_line = {},
    frame_paths_by_frame_id = {},
    frame_line_by_frame_id = {},
    breakpoint_paths_by_line = {},
    breakpoint_lines_by_line = {},
    expression_views_by_line = {},
    variable_views_by_line = {},
    sessions_by_line = {},
    subtle_frames = false,
    watched_expressions = {},
    variable_path_is_expanded = {},
    variable_path_to_evaluate_name = {},
    variable_path_to_value = {},
    variable_path_to_parent_reference = {},
    variable_path_to_name = {},
    line_to_variable_path = {},
    cur_pos = {},
}

return M
