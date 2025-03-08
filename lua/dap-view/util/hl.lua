local state = require("dap-view.state")
local globals = require("dap-view.globals")

local M = {}

---@param hl_group string
---@param start [integer,integer]
---@param finish [integer,integer]
M.hl_range = function(hl_group, start, finish)
    vim.hl.range(state.bufnr, globals.NAMESPACE, "NvimDapView" .. hl_group, start, finish)
end

---@param row integer
---@param len_path integer
---@param len_lnum integer
M.highlight_file_name_and_line_number = function(row, len_path, len_lnum)
    local lnum_start = len_path + 1
    local lnum_end = lnum_start + len_lnum

    M.hl_range("FileName", { row, 0 }, { row, len_path })
    M.hl_range("LineNumber", { row, lnum_start }, { row, lnum_end })
    M.hl_range("Separator", { row, lnum_start - 1 }, { row, lnum_start })
    M.hl_range("Separator", { row, lnum_end }, { row, lnum_end + 1 })
end

return M
