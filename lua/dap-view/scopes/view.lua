local dap = require("dap")

local views = require("dap-view.views")
local state = require("dap-view.state")
local setup = require("dap-view.setup")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

---@type dap.Session
local session

---@type integer
local frame_id

---Redrawing is jittery if we set lines on the fly
---Prevent that by batching all buffer updates
---Also need to handle concurrent calls, by creating multiple instances
---@class dapview.Canvas
---@field contents string[]
---@field highlights [string, [integer,integer], [integer,integer]][][]

---@param variables_reference integer
---@param parent_path string
---@param line integer
---@param depth integer
---@param canvas dapview.Canvas
local function show_variables(variables_reference, parent_path, line, depth, canvas)
    local err, response = session:request(
        "variables",
        { variablesReference = variables_reference, context = "variables", frameId = frame_id }
    )

    if err then
        local err_content = string.rep("\t", depth + 1) .. tostring(err)

        canvas.contents[#canvas.contents + 1] = err_content

        canvas.highlights[#canvas.highlights + 1] = { { "WatchError", { line, 0 }, { line, #err_content } } }

        line = line + 1

        return line
    end

    local variables = response and response.variables or {}

    local sort_variables = setup.config.render.sort_variables
    if sort_variables then
        table.sort(variables, sort_variables)
    end

    for _, variable in pairs(variables) do
        local show_expand_hint = #variable.value == 0 and variable.variablesReference > 0
        local value = show_expand_hint and "..." or variable.value
        local variable_name = variable.name

        local path = parent_path .. "." .. variable.name

        local prefix = util.get_variable_prefix(variable, state.variable_path_is_expanded[path])

        local content = prefix .. variable_name .. " = " .. value

        -- Can't have linebreaks with nvim_buf_set_lines
        local trimmed_content = content:gsub("%s+", " ")

        local indented_content = string.rep("\t", depth) .. trimmed_content

        canvas.contents[#canvas.contents + 1] = indented_content

        hl.hl_range("WatchExpr", { line, depth + #prefix }, { line, depth + #prefix + #variable.name })

        local prev_variable_value = state.variable_path_to_value[path]

        local updated = prev_variable_value and prev_variable_value ~= variable.value

        state.variable_path_to_value[path] = variable.value
        state.variable_path_to_name[path] = variable.name
        state.variable_path_to_evaluate_name[path] = variable.evaluateName
        state.variable_path_to_parent_reference[path] = variables_reference

        local type_hl_group = (updated and "WatchUpdated")
            or (show_expand_hint and "WatchMore")
            or (variable.type and hl.types_to_hl_group[variable.type:lower()])

        canvas.highlights[#canvas.highlights + 1] = {
            { "WatchExpr", { line, depth + #prefix }, { line, depth + #prefix + #variable.name } },
            type_hl_group and { type_hl_group, { line, #variable_name + 3 + depth + #prefix }, { line, -1 } } or nil,
        }

        line = line + 1

        state.line_to_variable_path[line] = path

        if state.variable_path_is_expanded[path] and variable.variablesReference > 0 then
            line = show_variables(variable.variablesReference, path, line, depth + 1, canvas)
        end
    end

    return line
end

M.show = function()
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        local tmp_session = dap.session()

        if views.cleanup_view(tmp_session == nil, "No active session") then
            return
        end

        ---@cast tmp_session dap.Session

        session = tmp_session

        local current_frame = session.current_frame

        if views.cleanup_view(current_frame == nil, "Session not stopped") then
            return
        end

        ---@cast current_frame dap.StackFrame

        frame_id = current_frame.id

        local frame_scopes = current_frame.scopes

        local is_empty = frame_scopes == nil or vim.tbl_isempty(frame_scopes)

        if views.cleanup_view(is_empty, "No scopes for the current frame") then
            return
        end

        ---@cast frame_scopes dap.Scope[]

        ---@type dap.Scope[]
        local filtered_scopes = {}
        for _, scope in ipairs(frame_scopes) do
            if not scope.expensive then
                table.insert(filtered_scopes, scope)
            end
        end

        local line = 0

        ---@type dapview.Canvas
        local canvas = { contents = {}, highlights = {} }

        for _, scope in ipairs(filtered_scopes) do
            canvas.contents[#canvas.contents + 1] = scope.name

            canvas.highlights[#canvas.highlights + 1] = { { "Thread", { line, 0 }, { line, -1 } } }

            line = line + 1

            line = show_variables(scope.variablesReference, scope.name, line, 1, canvas)
        end

        api.nvim_buf_set_lines(state.bufnr, 0, line - 1, false, canvas.contents)

        for _, highlights in ipairs(canvas.highlights) do
            for _, highlight in ipairs(highlights) do
                hl.hl_range(highlight[1], highlight[2], highlight[3])
            end
        end

        api.nvim_buf_set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
