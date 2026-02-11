local dap = require("dap")

local views = require("dap-view.views")
local state = require("dap-view.state")
local setup = require("dap-view.setup")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")
local fmt = require("dap-view.util.fmt")

local M = {}

---@type dap.Session
local session

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
    local err, response = session:request("variables", { variablesReference = variables_reference })

    if err then
        local err_content = string.rep("\t", depth + 1) .. fmt.dap_error(err)

        canvas.contents[#canvas.contents + 1] = err_content

        canvas.highlights[#canvas.highlights + 1] = { { "WatchError", { line, 0 }, { line, #err_content } } }

        line = line + 1

        return line
    end

    local variables = response and response.variables or {}

    local config = setup.config
    local sort_variables = config.render.sort_variables
    if sort_variables then
        table.sort(variables, sort_variables)
    end

    for _, variable in pairs(variables) do
        local variable_name = variable.name

        local path = parent_path .. "." .. variable.name

        local is_expanded = state.variable_path_is_expanded[path]
        local is_structured = variable.variablesReference > 0

        local prefix = ""

        if is_structured then
            prefix = is_expanded and config.icons.expanded or config.icons.collapsed
        end

        local value = variable.value
        local content = prefix .. variable_name .. (#value > 0 and " = " or "") .. value

        -- Can't have linebreaks with nvim_buf_set_lines
        local trimmed_content = content:gsub("%s+", " ")

        local indented_content = string.rep("\t", depth) .. trimmed_content

        canvas.contents[#canvas.contents + 1] = indented_content

        local prev_variable_value = state.variable_path_to_value[path]

        local updated = prev_variable_value and prev_variable_value ~= variable.value

        state.variable_path_to_value[path] = variable.value
        state.variable_path_to_name[path] = variable.name
        state.variable_path_to_evaluate_name[path] = variable.evaluateName
        state.variable_path_to_parent_reference[path] = variables_reference

        local type_hl_group = (updated and "WatchUpdated")
            or (variable.type and hl.types_to_hl_group[variable.type:lower()])

        local hl_start = depth + #prefix
        canvas.highlights[#canvas.highlights + 1] = {
            { "WatchExpr", { line, hl_start }, { line, hl_start + #variable.name } },
            type_hl_group and { type_hl_group, { line, hl_start + #variable_name + 3 }, { line, -1 } } or nil,
        }

        line = line + 1

        state.line_to_variable_path[line] = path

        if is_expanded and is_structured then
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

        if views.cleanup_view(vim.tbl_isempty(filtered_scopes), "No eligible scopes returned from adapter") then
            return
        end

        local all_scopes_collapsed = vim.iter(filtered_scopes):all(
            ---@param s dap.Scope
            function(s)
                return vim.iter(state.collapsed_scopes):find(function(s_)
                    return s_ == s.name
                end)
            end
        )

        -- If all scopes are manually collapsed,
        -- we can reasonably assume it's likely at least one of them has variables
        local has_variables = all_scopes_collapsed

        local line = 0

        for k, _ in pairs(state.line_to_scope_name) do
            state.line_to_scope_name[k] = nil
        end
        for k, _ in pairs(state.line_to_variable_path) do
            state.line_to_variable_path[k] = nil
        end

        ---@type dapview.Canvas
        local canvas = { contents = {}, highlights = {} }

        for _, scope in ipairs(filtered_scopes) do
            canvas.contents[#canvas.contents + 1] = scope.name

            canvas.highlights[#canvas.highlights + 1] = { { "Thread", { line, 0 }, { line, -1 } } }

            line = line + 1

            state.line_to_scope_name[line] = scope.name

            local prev_line = line

            if not vim.tbl_contains(state.collapsed_scopes, scope.name) then
                line = show_variables(scope.variablesReference, scope.name, line, 1, canvas)
            end

            if prev_line ~= line then
                has_variables = true
            end
        end

        -- Sometimes the JS debug adapter simply does not return any variables at all, in spite of
        -- returning the scopes themselves. This happens, for instance, when debugging firebase functions.
        -- Upon refreshing the scopes for a function that is no longer in execution.
        --
        -- This could be a bug in nvim-dap where it does not refresh the scopes, or a bug with the
        -- adapter itself, where it doesn't send the updated scopes (if there are none)
        --
        -- Either way, that's not much of a big deal
        --
        -- More concerning though, is the fact that if the user does not force a refresh,
        -- The scopes may show "outdated info" until a trigger to refresh is hit
        -- But I guess that's more of a feature instead of a bug?
        if views.cleanup_view(not has_variables, "No variables returned from adapter") then
            return
        end

        util.set_lines(state.bufnr, 0, line - 1, false, canvas.contents)

        for _, highlights in ipairs(canvas.highlights) do
            for _, highlight in ipairs(highlights) do
                hl.hl_range(highlight[1], highlight[2], highlight[3])
            end
        end

        util.set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
