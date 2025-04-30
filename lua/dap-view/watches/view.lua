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

---@param line integer
---@param response string|dap.EvaluateResponse
---@return integer
local show_variables = function(line, response)
    if type(response) ~= "string" then
        local variables = state.variables_by_reference[response.variablesReference]
        if type(variables) == "string" then
            local var_content = "\t" .. variables
            api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { var_content })

            line = line + 1
        else
            for _, var in ipairs(variables or {}) do
                local variable = var.variable
                local value = #variable.value > 0 and variable.value
                    or variable.variablesReference > 0 and "..."
                    or ""
                local content = variable.name .. " = " .. value

                -- Can't have linebreaks with nvim_buf_set_lines
                local trimmed_content = content:gsub("%s+", " ")

                api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { "\t" .. trimmed_content })

                hl.hl_range("WatchExpr", { line, 1 }, { line, 1 + #variable.name })

                local hl_group = var.updated and "WatchUpdated" or types_to_hl_group[variable.type:lower()]
                if hl_group then
                    local _hl_start = #variable.name + 4
                    hl.hl_range(hl_group, { line, _hl_start }, { line, -1 })
                end

                line = line + 1

                state.variables_by_line[line] = { response = variable }
            end
        end
    end
    return line
end

M.show = function()
    winbar.update_section("watches")

    if state.bufnr then
        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

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
        for expr, eval in pairs(state.watched_expressions) do
            local response = eval.response

            assert(response ~= nil, "Response exists")

            local result = type(response) == "string" and response or response.result

            local content = expr .. " = " .. result

            -- Can't have linebreaks with nvim_buf_set_lines
            local trimmed_content = content:gsub("%s+", " ")

            api.nvim_buf_set_lines(state.bufnr, line, line + 1, false, { trimmed_content })

            hl.hl_range("WatchExpr", { line, 0 }, { line, #expr })

            local hl_group = type(response) == "string" and "WatchError"
                or eval.updated and "WatchUpdated"
                or response and types_to_hl_group[response.type:lower()]
            if hl_group then
                local hl_start = #expr + 3
                hl.hl_range(hl_group, { line, hl_start }, { line, -1 })
            end

            line = line + 1

            state.expressions_by_line[line] = { name = expr, response = response }

            line = show_variables(line, response)
        end
    end
end

return M
