local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")
local vendor = require("dap-view.breakpoints.vendor")
local extmarks = require("dap-view.breakpoints.util.extmarks")
local treesitter = require("dap-view.breakpoints.util.treesitter")
local views = require("dap-view.views")
local hl = require("dap-view.util.hl")

local api = vim.api

local M = {}

---@param row integer
---@param len_path integer
---@param len_lnum integer
local highlight_file_name_and_line_number = function(row, len_path, len_lnum)
    if state.bufnr then
        local lnum_start = len_path + 1
        local lnum_end = lnum_start + len_lnum

        hl.hl_range("FileName", { row, 0 }, { row, len_path })
        hl.hl_range("LineNumber", { row, lnum_start }, { row, lnum_end })
        hl.hl_range("Separator", { row, lnum_start - 1 }, { row, lnum_start })
        hl.hl_range("Separator", { row, lnum_end }, { row, lnum_end + 1 })
    end
end

local populate_buf_with_breakpoints = function()
    if state.bufnr then
        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

        local breakpoints = vendor.get()

        local line_count = 0

        if views.cleanup_view(vim.tbl_isempty(breakpoints), "No breakpoints") then
            return
        end

        for buf, buf_entries in pairs(breakpoints) do
            local filename = api.nvim_buf_get_name(buf)
            local relative_path = vim.fn.fnamemodify(filename, ":.")

            for _, entry in pairs(buf_entries) do
                local line_content = {}

                local buf_lines = api.nvim_buf_get_lines(buf, entry.lnum - 1, entry.lnum, true)
                local text = table.concat(buf_lines, "\n")

                table.insert(line_content, relative_path .. "|" .. entry.lnum .. "|" .. text)

                api.nvim_buf_set_lines(state.bufnr, line_count, line_count, false, line_content)

                local col_offset = #relative_path + #tostring(entry.lnum) + 2

                treesitter.copy_highlights(buf, entry.lnum - 1, line_count, col_offset)
                extmarks.copy_extmarks(buf, entry.lnum - 1, line_count, col_offset)

                highlight_file_name_and_line_number(line_count, #relative_path, #tostring(entry.lnum))

                line_count = line_count + 1
            end
        end

        -- Remove the last line, as it's empty (for some reason)
        api.nvim_buf_set_lines(state.bufnr, -2, -1, false, {})
    end
end

M.show = function()
    winbar.update_winbar("breakpoints")

    populate_buf_with_breakpoints()
end

return M
