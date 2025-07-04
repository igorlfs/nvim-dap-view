local state = require("dap-view.state")
local vendor = require("dap-view.breakpoints.vendor")
local extmarks = require("dap-view.breakpoints.util.extmarks")
local treesitter = require("dap-view.breakpoints.util.treesitter")
local views = require("dap-view.views")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

M.show = function()
    -- We have to check if the win is valid, since this function may be triggered by an event when the window is closed
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
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

        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
