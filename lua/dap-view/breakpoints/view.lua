local state = require("dap-view.state")
local vendor = require("dap-view.breakpoints.vendor")
local extmarks = require("dap-view.breakpoints.util.extmarks")
local treesitter = require("dap-view.breakpoints.util.treesitter")
local setup = require("dap-view.setup")
local views = require("dap-view.views")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")

local M = {}

---@class dapview.Breakpoint
---@field path string
---@field lnum string
---@field line string

local api = vim.api

M.show = function()
    -- We have to check if the win is valid, since this function may be triggered by an event when the window is closed
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        local breakpoints = vendor.get()

        local line = 0

        if views.cleanup_view(vim.tbl_isempty(breakpoints), "No breakpoints") then
            return
        end

        for i, _ in ipairs(state.breakpoint_paths_by_line) do
            state.breakpoint_paths_by_line[i] = nil
        end

        for i, _ in ipairs(state.breakpoint_lines_by_line) do
            state.breakpoint_lines_by_line[i] = nil
        end

        ---@type integer[][]
        local lengths = {}

        local num_parts = 0

        for buf, buf_entries in pairs(breakpoints) do
            local filename = api.nvim_buf_get_name(buf)
            local relative_path = vim.fn.fnamemodify(filename, ":.")

            for _, entry in pairs(buf_entries) do
                local buf_lines = api.nvim_buf_get_lines(buf, entry.lnum - 1, entry.lnum, true)
                local text = table.concat(buf_lines, "\n")

                local parts = setup.config.render.breakpoints.format(text, tostring(entry.lnum), relative_path)

                for _, p in ipairs(parts) do
                    assert(not p.separator or #p.separator == 1, "Separator length must not exceeed 1 character")
                end

                num_parts = #parts - 1

                lengths[#lengths + 1] = vim.iter(parts)
                    :map(
                        ---@param part dapview.Content
                        function(part)
                            return #part.part
                        end
                    )
                    :totable()

                table.insert(state.breakpoint_paths_by_line, relative_path)
                table.insert(state.breakpoint_lines_by_line, entry.lnum)

                local content = ""
                for k, p in ipairs(parts) do
                    content = content .. p.part
                    if k ~= #parts then
                        content = content .. (p.separator or "|")
                    end
                end

                util.set_lines(state.bufnr, line, line, false, { content })

                local hl_init = 0
                for _, p in ipairs(parts) do
                    if p.hl then
                        local hl_end = hl_init + #p.part

                        if type(p.hl) == "string" then
                            ---@cast p {hl: string}
                            hl.hl_range(p.hl, { line, hl_init }, { line, hl_end })
                        else
                            treesitter.copy_highlights(buf, entry.lnum - 1, line, hl_init)
                            extmarks.copy_extmarks(buf, entry.lnum - 1, line, hl_init)
                        end

                        hl.hl_range("Separator", { line, hl_end }, { line, hl_end + 1 })

                        hl_init = hl_init + #p.part + 1
                    end
                end

                line = line + 1
            end
        end

        if setup.config.render.breakpoints.align then
            require("dap-view.util.align").align(num_parts, lengths)
        end

        -- Clear previous content
        util.set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
