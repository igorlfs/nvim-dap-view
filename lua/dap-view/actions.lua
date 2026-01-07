local dap = require("dap")

local winbar = require("dap-view.options.winbar")
local setup = require("dap-view.setup")
local util = require("dap-view.util")
local autocmd = require("dap-view.options.autocmd")
local term = require("dap-view.console.view")
local state = require("dap-view.state")
local globals = require("dap-view.globals")
local tables = require("dap-view.util.tables")
local traversal = require("dap-view.tree.traversal")

local M = {}

local api = vim.api
local go = vim.go

---@param hide_terminal? boolean
M.toggle = function(hide_terminal)
    if util.is_win_valid(state.winnr) then
        M.close(hide_terminal)
    else
        M.open(hide_terminal)
    end
end

---@param hide_terminal? boolean
M.close = function(hide_terminal)
    if state.current_section == "repl" then
        dap.repl.close({ mode = "toggle" })
    end

    if util.is_win_valid(state.winnr) then
        -- Avoid "E444: Cannot close last window"
        pcall(api.nvim_win_close, state.winnr, true)
    end

    state.winnr = nil

    if util.is_buf_valid(state.bufnr) then
        api.nvim_buf_delete(state.bufnr, { force = true })
    end

    state.bufnr = nil

    -- Close leftover terminal (if left open in another tab)
    -- Might not be considered leftover, though. Let the caller decide
    if hide_terminal and state.last_term_winnr ~= state.term_winnr and util.is_win_valid(state.last_term_winnr) then
        api.nvim_win_close(state.last_term_winnr, true)
    end

    if hide_terminal then
        term.hide_term_buf_win()
    end
end

---@param hide_terminal? boolean
M.open = function(hide_terminal)
    M.close(hide_terminal)

    -- Force closing leftover terminal when reopening, even when not hiding term explicitly
    -- Prevents opening multiple terminal windows
    if not hide_terminal and state.last_term_winnr ~= state.term_winnr and util.is_win_valid(state.last_term_winnr) then
        api.nvim_win_close(state.last_term_winnr, true)
    end

    local bufnr = api.nvim_create_buf(false, false)

    assert(bufnr ~= 0, "Failed to create nvim-dap-view buffer")

    state.bufnr = bufnr

    -- Handle session restoration, where a leftover buffer can prevent reopening (#132)
    for _, buf in ipairs(api.nvim_list_bufs()) do
        local name = api.nvim_buf_get_name(buf)
        if name == globals.MAIN_BUF_NAME then
            api.nvim_buf_delete(buf, { force = true })
        end
    end

    api.nvim_buf_set_name(bufnr, globals.MAIN_BUF_NAME)

    local separate_term_win = not vim.tbl_contains(setup.config.winbar.sections, "console")
    local term_winnr = separate_term_win and term.open_term_buf_win()

    local is_term_win_valid = util.is_win_valid(term_winnr)

    local windows_config = setup.config.windows
    local term_config = windows_config.terminal

    local position = windows_config.position
    local win_pos = (type(position) == "function" and position(state.win_pos))
        or (type(position) == "string" and position)

    ---@cast win_pos dapview.Position

    state.win_pos = win_pos

    local term_position_ = term_config.position
    local term_win_pos = (type(term_position_) == "function" and term_position_(win_pos))
        or (type(term_position_) == "string" and term_position_)

    ---@cast term_win_pos dapview.Position

    local inv_term_position = util.inverted_directions[term_win_pos]

    local anchor_win = windows_config.anchor and windows_config.anchor()
    local is_anchor_win_valid = util.is_win_valid(anchor_win)

    local size_ = windows_config.size
    local size__ = (type(size_) == "function" and size_(win_pos)) or size_

    ---@cast size__ number

    local is_vertical = win_pos == "above" or win_pos == "below"

    local term_size_ = term_config.size
    local term_size__ = (type(term_size_) == "function" and term_size_(inv_term_position)) or term_size_

    ---@cast term_size__ number

    local term_is_vertical = term_win_pos == "above" or term_win_pos == "below"

    local is_win_valid = is_anchor_win_valid or is_term_win_valid

    local size = size__ < 1 and math.floor((is_vertical and go.lines or go.columns) * size__) or size__

    local shared_split = term_is_vertical == is_vertical

    local winfix_setting = is_vertical and "winfixheight" or "winfixwidth"

    -- Temporarily disable fixed size
    -- If the window exists, it's using the space of both
    -- Do not touch anchor because we don't own it
    if is_term_win_valid and shared_split then
        vim.wo[state.term_winnr][winfix_setting] = false

        -- `size` is already an integer at this point
        if term_size__ < 1 then
            term_size__ = term_size__ * size
        end
    end

    local go_max = term_is_vertical and go.lines or go.columns

    local term_size = term_size__ < 1 and math.floor(go_max * term_size__) or math.floor(term_size__)

    local winnr = api.nvim_open_win(bufnr, false, {
        split = is_win_valid and inv_term_position or win_pos,
        win = is_anchor_win_valid and anchor_win or is_term_win_valid and term_winnr or -1,
        -- Oh lord
        height = (
            is_win_valid and (term_is_vertical and ((is_vertical and size or go.lines) - term_size) or size)
            or (is_vertical and size or nil)
        ),
        width = (
            is_win_valid
                and (not term_is_vertical and ((not is_vertical and size or go.columns) - term_size) or size)
            or (not is_vertical and size or nil)
        ),
    })

    -- Restore fixed size
    if is_term_win_valid and shared_split then
        vim.wo[state.term_winnr][winfix_setting] = true
    end

    assert(winnr ~= 0, "Failed to create nvim-dap-view window")

    state.winnr = winnr

    vim.w[state.winnr].dapview_win = true

    require("dap-view.views.options").set_options()
    require("dap-view.views.keymaps").set_keymaps()

    state.current_section = state.current_section or setup.config.winbar.default_section

    winbar.set_action_keymaps()
    winbar.show_content(state.current_section)

    -- Clean up states dap-view buffer is wiped out
    autocmd.quit_buf_autocmd(state.bufnr, function()
        -- The buffer is already being wiped out, so prevent close() from doing it again.
        state.bufnr = nil

        M.close()
    end)
end

---@param expr? string
---@param default_expanded boolean
M.add_expr = function(expr, default_expanded)
    local expr_ = expr or require("dap-view.util.exprs").get_current_expr()
    coroutine.wrap(function()
        if require("dap-view.watches.actions").add_watch_expr(expr_, default_expanded) then
            require("dap-view.views").switch_to_view("watches")
        end
    end)()
end

---@param view dapview.Section|string
M.jump_to_view = function(view)
    if not vim.tbl_contains(setup.config.winbar.sections, view) then
        vim.notify("Can't jump to unconfigured view: " .. view)
        return
    end
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        api.nvim_set_current_win(state.winnr)
        winbar.show_content(view)
    else
        vim.notify("Can't jump to view: couldn't find the window")
    end
end

---@param view dapview.Section|string
M.show_view = function(view)
    if not vim.tbl_contains(setup.config.winbar.sections, view) then
        vim.notify("Can't show unconfigured view: " .. view)
        return
    end
    if state.current_section == view then
        M.jump_to_view(view)
    elseif util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        winbar.show_content(view)
    else
        vim.notify("Can't show view: couldn't find the window")
    end
end

---@param id string
---@param section dapview.CustomSectionConfig
M.register_view = function(id, section)
    setup.config.winbar.custom_sections[id] = section
end

---@class dapview.NavigateOpts
---@field wrap boolean
---@field count number
---@field type? "views" | "sessions"

---@param opts dapview.NavigateOpts
M.navigate = function(opts)
    local is_session = opts.type == "sessions"

    if (not util.is_buf_valid(state.bufnr) or not util.is_win_valid(state.winnr)) and not is_session then
        vim.notify("Can't navigate within views: couldn't find the window")
        return
    end

    local session = dap.session()

    if not session and is_session then
        vim.notify("Can't navigate within sessions: no session running")
        return
    end

    -- We actually need to flatten the session, because sessions can be nested
    local array = is_session and traversal.flatten_sessions(dap.sessions()) or setup.config.winbar.sections
    local idx, sorted_keys = unpack(tables.index_of(array, is_session and session or state.current_section) or {})

    if idx == nil then
        vim.notify("Can't navigate: couldn't find the current object")
        return
    end

    local new_idx = idx + opts.count
    -- Length operator is unreliable for tables with gaps
    local len = #sorted_keys

    if opts.wrap then
        new_idx = ((new_idx - 1) % len) + 1
    else
        new_idx = math.min(len, math.max(1, new_idx))
    end

    if opts.type == "sessions" then
        ---@cast array table<number,dap.Session>
        dap.set_session(array[sorted_keys[new_idx]])
    else
        ---@cast array dapview.Section[]
        local new_view = array[sorted_keys[new_idx]]

        winbar.show_content(new_view)
    end
end

return M
