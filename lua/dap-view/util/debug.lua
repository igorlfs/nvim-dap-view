local setup = require("dap-view.setup")

local M = {}

---@param value any
---@return string
local function to_debug_string(value)
    if type(value) == "table" then
        return vim.inspect(value)
    end

    if value == nil then
        return "nil"
    end

    return tostring(value)
end

---@param label string
---@param value any
---@param value_hl? string
---@return table
local function debug_row(label, value, value_hl)
    local text = to_debug_string(value)
    local lines = vim.split(text, "\n", { plain = true })

    local chunks = {
        { string.format("%-18s", label .. ":"), "DiagnosticHint" },
        { lines[1] or "", value_hl or "String" },
        { "\n" },
    }

    for i = 2, #lines do
        vim.list_extend(chunks, {
            { string.rep(" ", 18), "DiagnosticHint" },
            { lines[i], value_hl or "String" },
            { "\n" },
        })
    end

    return chunks
end

---@param rows { label: string, value: any, hl?: string }[]
M.debug_table = function(rows)
    if not setup.config.debug_mode then
        return
    end

    local chunks = {}

    for _, row in ipairs(rows) do
        vim.list_extend(chunks, debug_row(row.label, row.value, row.hl))
    end

    vim.api.nvim_echo(chunks, true, {})
end

return M
