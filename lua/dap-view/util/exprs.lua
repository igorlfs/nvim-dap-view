local M = {}

local api = vim.api

---@return string
M.get_trimmed_selection = function()
    local start = vim.fn.getpos("'<")
    local finish = vim.fn.getpos("'>")

    local start_line, start_col = start[2], start[3]
    local finish_line, finish_col = finish[2], finish[3]

    if start_line > finish_line or (start_line == finish_line and start_col > finish_col) then
        start_line, start_col, finish_line, finish_col = finish_line, finish_col, start_line, start_col
    end

    local lines = vim.fn.getline(start_line, finish_line)
    if #lines == 0 then
        return ""
    end

    -- It's easier to manipulate a single line as if it were a string
    if #lines == 1 then
        lines = lines[1]
    end

    if type(lines) == "string" then
        return string.sub(lines, start_col, finish_col)
    end

    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, finish_col)

    -- Trim to simplify final expression
    local trimmed_lines = vim.iter(lines)
        :map(function(line)
            return vim.trim(line)
        end)
        :totable()

    return table.concat(trimmed_lines, "")
end

---@return string
M.get_current_expr = function()
    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" then
        -- Return to normal mode
        local keys = api.nvim_replace_termcodes("<Esc>", true, true, true)
        api.nvim_feedkeys(keys, "x", false)

        return M.get_trimmed_selection()
    end

    return vim.fn.expand("<cexpr>")
end

return M
