local globals = require("dap-view.globals")
local state = require("dap-view.state")

local M = {}

local api = vim.api

---@param num_parts integer
---@param lengths integer[][]
---@param col_offset? integer
---@param row_offsets? integer[]
M.align = function(num_parts, lengths, col_offset, row_offsets)
    col_offset = col_offset or 0
    row_offsets = row_offsets or {}

    ---@type integer[]
    local maxes = {}
    ---@type integer[][]
    local diffs = {}

    for _ = 1, num_parts do
        maxes[#maxes + 1] = 0
    end

    for i = 1, num_parts do
        for j = 1, #lengths do
            diffs[#diffs + 1] = {}
            if lengths[j][i] > maxes[i] then
                maxes[i] = lengths[j][i]
            end
        end
    end

    for i = 1, num_parts do
        for j = 1, #lengths do
            diffs[j][i] = maxes[i] - lengths[j][i]
        end
    end

    for i, k in ipairs(diffs) do
        local cur_col = col_offset

        for j, v in ipairs(k) do
            local row = i - 1
            if row_offsets[i] then
                row = row + row_offsets[i]
            end

            local col = lengths[i][j] + cur_col

            -- Account for the separator
            cur_col = col + 1

            if v > 0 then
                api.nvim_buf_set_extmark(state.bufnr, globals.NAMESPACE, row, col, {
                    virt_text = { { string.rep(" ", v) } },
                    virt_text_pos = "inline",
                })
            end
        end
    end
end

return M
