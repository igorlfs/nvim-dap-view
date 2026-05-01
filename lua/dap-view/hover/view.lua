local state = require("dap-view.state")
local setup = require("dap-view.setup")
local hl = require("dap-view.util.hl")
local util = require("dap-view.util")
local fmt = require("dap-view.util.fmt")

local M = {}

local fn = vim.fn

---@type dap.Session
local session

local width = 0

local MAX_WIDTH = math.floor(vim.go.columns * 0.8)

local MAX_HEIGHT = math.floor(vim.go.lines * 0.5)

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

        width = math.max(width, fn.strdisplaywidth(err_content))

        canvas.highlights[#canvas.highlights + 1] = { { "WatchError", { line, 0 }, { line, #err_content } } }

        line = line + 1

        return line
    end

    local parent_line = line

    local config = setup.config

    for _, variable in pairs(response and response.variables or {}) do
        local variable_name = variable.name

        local path = parent_path .. "." .. variable.name

        local is_expanded = state.hover_path_is_expanded[path]
        local is_structured = variable.variablesReference > 0

        local prefix = ""

        if is_structured then
            prefix = is_expanded and config.icons.expanded or config.icons.collapsed
        end

        local value = variable.value
        local content = prefix .. variable_name .. (#value > 0 and " = " or "") .. value

        -- Can't have linebreaks with nvim_buf_set_lines
        local trimmed_content = content:gsub("\n+", " ")

        local indented_content = string.rep("\t", depth) .. trimmed_content

        canvas.contents[#canvas.contents + 1] = indented_content

        -- `strdisplaywidth` does not like null characters
        local ok, w = pcall(fn.strdisplaywidth, indented_content)
        if ok then
            width = math.max(width, w)
        end

        state.hover_path_to_value[path] = value
        state.hover_path_to_name[path] = variable.name
        state.hover_path_to_parent_line[path] = parent_line
        state.hover_path_to_evaluate_name[path] = variable.evaluateName
        state.hover_path_to_parent_reference[path] = variables_reference

        local type_hl_group = hl.hl_from_variable(variable)

        local hl_start = depth + #prefix
        canvas.highlights[#canvas.highlights + 1] = {
            { "WatchExpr", { line, hl_start }, { line, hl_start + #variable.name } },
            type_hl_group and { type_hl_group, { line, hl_start + #variable_name + 3 }, { line, -1 } } or nil,
        }

        line = line + 1

        state.line_to_hover_path[line] = path

        if is_expanded and is_structured then
            line = show_variables(variable.variablesReference, path, line, depth + 1, canvas)
        end
    end

    return line
end

---@param bufnr integer
M.show = function(bufnr)
    local expr = assert(state.hover, "has hover")
    local hover = assert(state.hovered_expression, "has hover state")

    session = assert(require("dap").session(), "has active session")

    ---@type dapview.Canvas
    local canvas = { contents = {}, highlights = {} }

    local height = 0

    width = 0

    if hover.err then
        local err_msg = fmt.dap_error(hover.err)
        canvas.contents[#canvas.contents + 1] = err_msg
        canvas.highlights[#canvas.highlights + 1] = { { "WatchError", { height, 0 }, { height, -1 } } }

        width = #err_msg

        height = height + 1
    elseif hover.response then
        if hover.response.variablesReference > 0 then
            local config = setup.config

            local prefix = hover.expanded and config.icons.expanded or config.icons.collapsed
            local value = hover.response.result

            local content = prefix .. expr .. (#value > 0 and " = " or "") .. value

            -- Can't have linebreaks with nvim_buf_set_lines
            local trimmed_content = content:gsub("\n+", " ")

            canvas.contents[#canvas.contents + 1] = trimmed_content

            local type_hl_group = hl.hl_from_variable(hover.response)

            local hl_start = #prefix
            canvas.highlights[#canvas.highlights + 1] = {
                { "WatchExpr", { height, hl_start }, { height, hl_start + #expr } },
                type_hl_group and { type_hl_group, { height, hl_start + #expr + 3 }, { height, -1 } } or nil,
            }

            height = height + 1

            if hover.expanded then
                height = show_variables(hover.response.variablesReference, expr, height, 1, canvas)
            end

            width = math.max(width, fn.strdisplaywidth(trimmed_content))
        else
            local result = hover.response.result

            canvas.contents[#canvas.contents + 1] = result

            width = #result

            local type_hl_group = hl.hl_from_variable(hover.response)

            canvas.highlights[#canvas.highlights + 1] = {
                type_hl_group and { type_hl_group, { height, 0 }, { height, -1 } } or nil,
            }

            height = height + 1
        end
    end

    util.set_lines(bufnr, 0, height, false, canvas.contents)

    for _, highlights in ipairs(canvas.highlights) do
        for _, highlight in ipairs(highlights) do
            hl.hl_range(highlight[1], highlight[2], highlight[3], bufnr)
        end
    end

    util.set_lines(bufnr, height, -1, true, {})

    -- Clamp dimensions
    height = math.min(height, MAX_HEIGHT)
    width = math.min(width, MAX_WIDTH)

    return { height, width }
end

return M
