local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")
local vendor = require("dap-view.breakpoints.vendor")
local extmarks = require("dap-view.breakpoints.util.extmarks")
local treesitter = require("dap-view.breakpoints.util.treesitter")
local views = require("dap-view.views")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

M.show = function()
    winbar.update_section("breakpoints")

    if state.bufnr then
        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

        local breakpoints = vendor.get()

        local line = 0

        if views.cleanup_view(vim.tbl_isempty(breakpoints), "No breakpoints") then
            return
        end

        for buf, buf_entries in pairs(breakpoints) do
            local filename = api.nvim_buf_get_name(buf)
            local relative_path = vim.fn.fnamemodify(filename, ":.")

            for _, entry in pairs(buf_entries) do
                local buf_lines = api.nvim_buf_get_lines(buf, entry.lnum - 1, entry.lnum, true)
                local text = table.concat(buf_lines, "\n")

                local content = { relative_path .. "|" .. entry.lnum .. "|" .. text }

                api.nvim_buf_set_lines(state.bufnr, line, line, false, content)

                local col_offset = #relative_path + #tostring(entry.lnum) + 2

                treesitter.copy_highlights(buf, entry.lnum - 1, line, col_offset)
                extmarks.copy_extmarks(buf, entry.lnum - 1, line, col_offset)

                hl.highlight_file_name_and_line_number(line, #relative_path, #tostring(entry.lnum))

                line = line + 1
            end
        end

        -- Remove the last line, as it's empty (for some reason)
        api.nvim_buf_set_lines(state.bufnr, -2, -1, false, {})
    end
end

return M
