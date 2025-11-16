local state = require("dap-view.state")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

---@param condition boolean
---@param message string
M.cleanup_view = function(condition, message)
    assert(state.winnr ~= nil, "has nvim-dap-view window")
    assert(state.bufnr ~= nil, "has nvim-dap-view buffer")

    if condition then
        vim.wo[state.winnr][0].cursorline = false

        api.nvim_buf_set_lines(state.bufnr, 0, -1, false, { message })

        hl.hl_range("MissingData", { 0, 0 }, { 0, #message })
    else
        vim.wo[state.winnr][0].cursorline = true
    end

    return condition
end

---@param view dapview.Section
---@param skip_restore_cursor? boolean
M.switch_to_view = function(view, skip_restore_cursor)
    if not util.is_buf_valid(state.bufnr) or not util.is_win_valid(state.winnr) then
        return
    end

    local cursor_line = state.cur_pos[view] or 1

    -- Switch to main buf if using another one
    -- Users may have custom views so we need to check against base sections instead
    if
        not vim.tbl_contains(
            { "scopes", "watches", "threads", "exceptions", "breakpoints", "sessions" },
            state.current_section
        )
    then
        api.nvim_win_call(state.winnr, function()
            vim.wo[state.winnr][0].winfixbuf = false
            api.nvim_set_current_buf(state.bufnr)
            vim.wo[state.winnr][0].winfixbuf = true
        end)
    end

    require("dap-view.options.winbar").refresh_winbar(view)

    require("dap-view." .. view .. ".view").show()

    if not skip_restore_cursor then
        local buf_len = api.nvim_buf_line_count(state.bufnr)
        state.cur_pos[view] = math.min(cursor_line, buf_len)

        api.nvim_win_set_cursor(state.winnr, { state.cur_pos[view], 0 })
    end
end

return M
