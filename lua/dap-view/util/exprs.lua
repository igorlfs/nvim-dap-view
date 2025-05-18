local M = {}

M.get_selection = function(start, finish)
    local start_line, start_col = start[2], start[3]
    local finish_line, finish_col = finish[2], finish[3]

    if start_line > finish_line or (start_line == finish_line and start_col > finish_col) then
        start_line, start_col, finish_line, finish_col = finish_line, finish_col, start_line, start_col
    end

    local lines = vim.fn.getline(start_line, finish_line)
    if #lines == 0 then
        return ""
    end
    if type(lines) == "string" then
        return lines
    end
    lines[#lines] = string.sub(lines[#lines], 1, finish_col)
    lines[1] = string.sub(lines[1], start_col)
    return table.concat(lines, '')
end

M.get_current_expr = function()
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', false, true, true), 'nx', false)
        local start = vim.fn.getpos("'<")
        local finish = vim.fn.getpos("'>")
        return M.get_selection(start, finish)
    end
    return vim.fn.expand("<cexpr>")
end

return M
