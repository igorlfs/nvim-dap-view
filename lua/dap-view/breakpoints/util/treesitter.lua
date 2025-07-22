local globals = require("dap-view.globals")
local state = require("dap-view.state")

local M = {}

local api = vim.api

---@param src_bufnr integer
---@param src_row integer
---@param target_row integer
---@param col_offset integer
--- See https://github.com/stevearc/quicker.nvim/blob/049d66534d3de5920663ee1b8dd0096d70f55a67/lua/quicker/highlight.lua#L164
M.copy_highlights = function(src_bufnr, src_row, target_row, col_offset)
    local filetype = vim.filetype.match({ buf = src_bufnr })

    if not filetype then
        return
    end

    local lang = vim.treesitter.language.get_lang(filetype)

    if not lang then
        return
    end

    local line = api.nvim_buf_get_lines(src_bufnr, src_row, src_row + 1, false)
    local text = table.concat(line, "\n")

    local has_parser, parser = pcall(vim.treesitter.get_string_parser, text, lang)

    if not has_parser then
        return
    end

    local trees = parser:parse(true)
    local root = trees and trees[1]:root()
    local query = vim.treesitter.query.get(lang, "highlights")

    if not query or not root then
        return
    end

    local highlights = {}
    for capture, node, metadata in query:iter_captures(root, text) do
        if capture == nil then
            break
        end

        local range = vim.treesitter.get_range(node, text, metadata[capture])
        local start_row, start_col, _, end_row, end_col, _ = unpack(range)
        local capture_name = query.captures[capture]

        local hl = string.format("@%s.%s", capture_name, lang)

        if end_row > start_row then
            end_col = -1
        end

        table.insert(highlights, { start_col + col_offset, end_col + col_offset, hl })
    end

    for _, hl in ipairs(highlights) do
        local start_col, end_col, hl_group = hl[1], hl[2], hl[3]
        api.nvim_buf_set_extmark(state.bufnr, globals.NAMESPACE, target_row, start_col, {
            hl_group = hl_group,
            end_col = end_col,
            priority = 100,
            strict = false,
        })
    end
end

return M
