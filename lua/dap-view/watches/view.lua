local state = require("dap-view.state")
local views = require("dap-view.views")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")

local M = {}

---@param children dapview.VariableView[]
---@param reference number
---@param line integer
---@param depth integer
---@return integer
local function show_variables(children, reference, line, depth)
    for _, child in ipairs(children) do
        local variable = child.variable
        local show_expand_hint = #variable.value == 0 and variable.variablesReference > 0
        local value = show_expand_hint and "..." or variable.value
        local content = variable.name .. " = " .. value

        -- Can't have linebreaks with nvim_buf_set_lines
        local trimmed_content = content:gsub("%s+", " ")

        local indented_content = string.rep("\t", depth) .. trimmed_content

        util.set_lines(state.bufnr, line, line, true, { indented_content })

        hl.hl_range("WatchExpr", { line, depth }, { line, depth + #variable.name })

        local hl_group = (show_expand_hint and "WatchMore")
            or (child.updated and "WatchUpdated")
            or (variable.type and hl.types_to_hl_group[variable.type:lower()])

        if hl_group then
            local _hl_start = #variable.name + 3 + depth
            hl.hl_range(hl_group, { line, _hl_start }, { line, -1 })
        end

        line = line + 1

        state.variable_views_by_line[line] = { parent_reference = reference, variable = variable, view = child }

        if child.err then
            local err_content = string.rep("\t", depth + 1) .. tostring(child.err)

            util.set_lines(state.bufnr, line, line, true, { err_content })

            hl.hl_range("WatchError", { line, 0 }, { line, #err_content })

            line = line + 1
        end

        if child.expanded and child.children ~= nil then
            line = show_variables(child.children, child.reference, line, depth + 1)
        end
    end
    return line
end

M.show = function()
    -- Since variables aren't ordered, lines may change unexpectedly
    -- To handle that, always clear the storage table
    for k, _ in pairs(state.expression_views_by_line) do
        state.expression_views_by_line[k] = nil
    end
    -- Also clear variables for the same reason
    for k, _ in pairs(state.variable_views_by_line) do
        state.variable_views_by_line[k] = nil
    end

    -- We have to check if the win is valid, since this function may be triggered by an event when the window is closed
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        -- Ensure buf is valid before calling `cleanup_view`
        if views.cleanup_view(vim.tbl_isempty(state.watched_expressions), "No expressions") then
            return
        end

        local line = 0

        -- Sort expressions to keep a "stable" experience
        ---@type [string, dapview.ExpressionView][]
        local expressions = vim.iter(state.watched_expressions)
            :map(function(k, v)
                return { k, v }
            end)
            :totable()

        table.sort(
            expressions,
            ---@param lhs [string, dapview.ExpressionView]
            ---@param rhs [string, dapview.ExpressionView]
            function(lhs, rhs)
                return lhs[2].id < rhs[2].id
            end
        )

        for _, expression_view in ipairs(expressions) do
            local expression, view = unpack(expression_view)
            local response = view.response
            local err = view.err

            local result = response and response.result or err and tostring(err)

            local content = expression .. " = " .. result

            -- Can't have linebreaks with nvim_buf_set_lines
            local trimmed_content = content:gsub("%s+", " ")

            util.set_lines(state.bufnr, line, line, true, { trimmed_content })

            hl.hl_range("WatchExpr", { line, 0 }, { line, #expression })

            local hl_group = err and "WatchError"
                or view.updated and "WatchUpdated"
                or response and response.type and hl.types_to_hl_group[response.type:lower()]

            if hl_group then
                local hl_start = #expression + 3
                hl.hl_range(hl_group, { line, hl_start }, { line, -1 })
            end

            line = line + 1

            state.expression_views_by_line[line] = { expression = expression, view = view }

            if err == nil and view.children ~= nil and view.expanded and response ~= nil then
                line = show_variables(view.children, response.variablesReference, line, 1)
            end
        end

        util.set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
