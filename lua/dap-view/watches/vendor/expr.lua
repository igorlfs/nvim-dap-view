local M = {}

local api = vim.api

---@param expr nil|string
---@return string
M.eval_expression = function(expr)
    local mode = api.nvim_get_mode()
    if mode.mode == "v" then
        -- [bufnum, lnum, col, off]; 1-indexed
        local start = vim.fn.getpos("v")
        local end_ = vim.fn.getpos(".")

        local start_row = start[2]
        local start_col = start[3]

        local end_row = end_[2]
        local end_col = end_[3]

        if start_row == end_row and end_col < start_col then
            end_col, start_col = start_col, end_col
        elseif end_row < start_row then
            start_row, end_row = end_row, start_row
            start_col, end_col = end_col, start_col
        end

        api.nvim_feedkeys(api.nvim_replace_termcodes("<ESC>", true, false, true), "n", false)

        -- buf_get_text is 0-indexed; end-col is exclusive
        local lines = api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
        return table.concat(lines, "\n")
    end

    expr = expr or "<cexpr>"

    return vim.fn.expand(expr)
end

return M
