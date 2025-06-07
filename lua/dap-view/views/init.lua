local state = require("dap-view.state")
local winbar = require("dap-view.options.winbar")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

---@param condition boolean
---@param message string
M.cleanup_view = function(condition, message)
    assert(state.winnr ~= nil, "has nvim-dap-view window")

    if condition then
        vim.wo[state.winnr][0].cursorline = false

        api.nvim_buf_set_lines(state.bufnr, 0, -1, false, { message })

        hl.hl_range("MissingData", { 0, 0 }, { 0, #message })
    else
        vim.wo[state.winnr][0].cursorline = true
    end

    return condition
end

---@param view dapview.SectionType
M.switch_to_view = function(view)
    if not state.bufnr or not state.winnr or not api.nvim_win_is_valid(state.winnr) then
        return
    end

    local cursor_line = state.cur_pos[view] or 1

    if vim.tbl_contains({ "repl", "console" }, state.current_section) then
        api.nvim_win_call(state.winnr, function()
            api.nvim_set_current_buf(state.bufnr)
        end)
    end

    winbar.update_section(view)

    require("dap-view." .. view .. ".view").show()

    local buf_len = api.nvim_buf_line_count(state.bufnr)
    state.cur_pos[view] = math.min(cursor_line, buf_len)

    api.nvim_win_set_cursor(state.winnr, { state.cur_pos[view], 1 })
end

return M
