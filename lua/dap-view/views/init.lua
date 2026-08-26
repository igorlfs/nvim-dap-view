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
        vim.wo[state.winnr][0].cursorlineopt = "number"

        util.set_lines(state.bufnr, 0, -1, false, { message })

        hl.hl_range("MissingData", { 0, 0 }, { 0, #message })
    else
        vim.wo[state.winnr][0].cursorlineopt = "both"
    end

    return condition
end

-- current line is not enough to determine
-- if the context has changed,
-- so we get a few lines before and after the
local function get_context(bufnr, line)
    local start_line = math.max(line - 3, 0)
    local end_line = math.min(line + 2, api.nvim_buf_line_count(bufnr))
    return table.concat(api.nvim_buf_get_lines(bufnr, start_line, end_line, true), "\n")
end

local function get_view_buf(view)
    local current_buf = api.nvim_win_get_buf(state.winnr)
    if view == "console" and vim.bo[current_buf].filetype == "dap-view-term" then
        if util.is_buf_valid(current_buf) then
            return current_buf
        end

        if util.is_buf_valid(state.last_session_buf) then
            return state.last_session_buf
        end

        return nil
    end

    if view == "repl" then
        if util.is_buf_valid(current_buf) and vim.bo[current_buf].filetype == "dap-repl" then
            return current_buf
        end

        if util.is_buf_valid(state.last_repl_buf) then
            return state.last_repl_buf
        end

        return nil
    end

    return state.bufnr
end

local function save_view_state(view)
    if not view then
        return
    end

    if not util.is_win_valid(state.winnr) then
        return
    end

    local bufnr = get_view_buf(view)
    if not bufnr or not util.is_buf_valid(bufnr) then
        return
    end

    state.cur_pos = state.cur_pos or {}
    state.saved_context = state.saved_context or {}
    state.saved_view = state.saved_view or {}

    local cursor = api.nvim_win_get_cursor(state.winnr)
    local buf_len = api.nvim_buf_line_count(bufnr)

    if buf_len < 1 then
        state.cur_pos[view] = { 1, 0 }
        state.saved_context[view] = nil
        return
    end

    local line = math.min(cursor[1], buf_len)
    local current_line = api.nvim_buf_get_lines(bufnr, line - 1, line, true)[1] or ""

    local col = math.min(cursor[2], #current_line)

    state.cur_pos[view] = { line, col }
    state.saved_context[view] = get_context(bufnr, line)

    state.saved_view[view] = api.nvim_win_call(state.winnr, function()
        return vim.fn.winsaveview()
    end)
end
---@param view dapview.Section
---@param skip_restore_cursor? boolean
M.switch_to_view = function(view, skip_restore_cursor)
    if not util.is_buf_valid(state.bufnr) or not util.is_win_valid(state.winnr) then
        return
    end

    local previous_view = state.last_section

    -- Save cursor/context/scroll state before leaving the current tab.
    save_view_state(previous_view)

    local cursor_line, cursor_col = unpack(state.cur_pos[view] or { 1, 0 })

    if
        not vim.tbl_contains({
            "scopes",
            "watches",
            "threads",
            "exceptions",
            "breakpoints",
            "sessions",
        }, previous_view)
    then
        api.nvim_win_call(state.winnr, function()
            vim.wo[state.winnr][0].winfixbuf = false
            api.nvim_set_current_buf(state.bufnr)
            vim.wo[state.winnr][0].winfixbuf = true
        end)
    end

    require("dap-view.options.winbar").refresh_winbar()
    require("dap-view." .. view .. ".view").show()

    state.last_section = view

    if skip_restore_cursor then
        return
    end

    local bufnr = get_view_buf(view)
    if not bufnr or not util.is_buf_valid(bufnr) then
        return
    end

    local buf_len = api.nvim_buf_line_count(bufnr)
    if buf_len < 1 then
        return
    end

    local line = math.min(cursor_line, buf_len)
    local current_context = get_context(bufnr, line)

    state.saved_context = state.saved_context or {}

    local previous_context = state.saved_context[view]
    local context_changed = previous_context ~= nil and previous_context ~= current_context

    require("dap-view.util.debug").debug_table({
        {
            label = "View",
            value = view,
            hl = "String",
        },
        {
            label = "Context changed",
            value = context_changed,
            hl = context_changed and "DiagnosticWarn" or "DiagnosticOk",
        },
        {
            label = "Previous context",
            value = previous_context,
            hl = "Comment",
        },
        {
            label = "Current context",
            value = current_context,
            hl = "String",
        },
    })

    if context_changed then
        state.cur_pos[view] = { 1, 0 }
        state.saved_context[view] = get_context(bufnr, 1)
    else
        local current_line = api.nvim_buf_get_lines(bufnr, line - 1, line, true)[1] or ""

        local col = math.min(cursor_col, #current_line)

        state.cur_pos[view] = { line, col }
        state.saved_context[view] = current_context
    end

    api.nvim_win_set_cursor(state.winnr, state.cur_pos[view])

    local saved_view = state.saved_view and state.saved_view[view]

    if saved_view then
        saved_view.lnum = state.cur_pos[view][1]
        saved_view.col = state.cur_pos[view][2]

        api.nvim_win_call(state.winnr, function()
            vim.fn.winrestview(saved_view)
        end)
    end
end

return M
