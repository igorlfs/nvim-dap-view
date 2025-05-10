local state = require("dap-view.state")
local winbar = require("dap-view.options.winbar")
local views = require("dap-view.views")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

-- TODO There's also 'list' and 'dict'
local types_to_hl_group = {
    boolean = "Boolean",
    str = "String",
    string = "String",
    int = "Number",
    long = "Number",
    number = "Number",
    double = "Float",
    float = "Float",
    ["function"] = "Function",
}

---@param children dapview.VariablePack[]
---@param reference number
---@param line number
---@param depth number
---@return integer
local function show_variables(children, reference, line, depth)
    for _, var in pairs(children or {}) do
        local variable = var.variable
        local value = #variable.value > 0 and variable.value
            or variable.variablesReference > 0 and "..."
            or ""
        local content = variable.name .. " = " .. value

        -- Can't have linebreaks with nvim_buf_set_lines
        local trimmed_content = content:gsub("%s+", " ")

        local indent = string.rep("\t", depth)
        api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { indent .. trimmed_content })

        hl.hl_range("WatchExpr", { line, depth }, { line, depth + #variable.name })

        local hl_group = var.updated and "WatchUpdated"
            or variable.type and types_to_hl_group[variable.type:lower()]
        if hl_group then
            local _hl_start = #variable.name + 3 + depth
            hl.hl_range(hl_group, { line, _hl_start }, { line, -1 })
        end

        line = line + 1

        state.variables_by_line[line] = { response = variable, reference = reference }

        if var.expanded and var.children then
            if type(var.children) == "string" then
                local err_content = string.rep("\t", depth + 1) .. var.children
                api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { err_content })

                hl.hl_range("WatchError", { line, 0 }, { line, #err_content })

                line = line + 1
            else
                ---@cast var dapview.VariablePackStrict
                line = show_variables(var.children, var.reference, line, depth + 1)
            end
        end
    end
    return line
end

---@param line integer
---@param variables string|dapview.ExpressionPack
---@return integer
local show_variables_or_err = function(line, variables)
    local children = variables.children
    if type(children) == "string" then
        local var_content = "\t" .. variables
        api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { var_content })

        hl.hl_range("WatchError", { line, 0 }, { line, #var_content })

        line = line + 1
    elseif children ~= nil and variables.expanded then
        line = show_variables(children, variables.response.variablesReference, line, 1)
    end
    return line
end

M.show = function()
    winbar.update_section("watches")

    if not state.winnr or not api.nvim_win_is_valid(state.winnr) then
        return
    end

    if state.bufnr then
        local cursor_line = api.nvim_win_get_cursor(state.winnr)[1]

        views.cleanup_view(#state.watched_expressions == 0, "No expressions")

        -- Since variables aren't ordered, lines may change unexpectedly
        -- To handle that, always clear the storage table
        for k, _ in pairs(state.expressions_by_line) do
            state.expressions_by_line[k] = nil
        end
        -- Also clear variables for the same reason
        for k, _ in pairs(state.variables_by_line) do
            state.variables_by_line[k] = nil
        end

        local line = 0
        for expr_name, expr in pairs(state.watched_expressions) do
            local response = expr.response

            assert(response ~= nil, "Response exists")

            local result = type(response) == "string" and response or response.result

            local content = expr_name .. " = " .. result

            -- Can't have linebreaks with nvim_buf_set_lines
            local trimmed_content = content:gsub("%s+", " ")

            api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { trimmed_content })

            hl.hl_range("WatchExpr", { line, 0 }, { line, #expr_name })

            local hl_group = type(response) == "string" and "WatchError"
                or expr.updated and "WatchUpdated"
                or response and response.type and types_to_hl_group[response.type:lower()]
            if hl_group then
                local hl_start = #expr_name + 3
                hl.hl_range(hl_group, { line, hl_start }, { line, -1 })
            end

            line = line + 1

            state.expressions_by_line[line] = { name = expr_name, response = response }

            line = show_variables_or_err(line, expr)
        end

        -- Workaround to reduce jankiness when redrawing
        if line > 0 then
            local content = {}
            if cursor_line > line then
                for i = 1, cursor_line - line do
                    content[i] = ""
                end
            end
            api.nvim_buf_set_lines(state.bufnr, line, -1, true, content)

            api.nvim_win_set_cursor(state.winnr, { cursor_line, 1 })
        end
    end
end

return M
