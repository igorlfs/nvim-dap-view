local M = {}

M.get_current_expr = function()
    if vim.fn.mode() == 'v' then
        local start = vim.fn.getpos('v')
        local finish = vim.fn.getpos('.')
        local start_line, start_col = start[2], start[3]
        local finish_line, finish_col = finish[2], finish[3]

        if start_line > finish_line or (start_line == finish_line and start_col > finish_col) then
            start_line, start_col, finish_line, finish_col = finish_line, finish_col, start_line, start_col
        end

        local lines = vim.fn.getline(start_line, finish_line)
        if #lines == 0 then
            return ""
        end
        lines[#lines] = string.sub(lines[#lines], 1, finish_col)
        lines[1] = string.sub(lines[1], start_col)
        return table.concat(lines, ' ')
    end
    return vim.fn.expand("<cexpr>")
end

return M
