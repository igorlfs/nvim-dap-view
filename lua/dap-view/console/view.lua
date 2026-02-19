local dap = require("dap")

local adapter = require("dap-view.util.adapter")
local state = require("dap-view.state")
local winbar = require("dap-view.options.winbar")
local setup = require("dap-view.setup")
local views = require("dap-view.views")
local util = require("dap-view.util")
local scroll = require("dap-view.console.scroll")

local M = {}

local api = vim.api
local go = vim.go

---Workaround to fetch the term_buf for sessions created via `startDebugging` from js-debug-adapter
---Only the top-level session owns the buf, children need to traverse parents to get it
---The children sessions are the ones who actually control the interaction with the terminal
---Therefore, the term_buf should be associated with them
---@param session dap.Session
---@return integer?
M.fetch_term_buf = function(session)
    ---@type dap.Session?
    local parent = session
    while parent ~= nil do
        if parent.term_buf then
            return parent.term_buf
        end

        parent = parent.parent
    end
end

M.show = function()
    if not util.is_win_valid(state.winnr) or not util.is_buf_valid(state.bufnr) then
        return
    end

    -- Don't apply window options for the console, because there might no terminal

    local session = dap.session()

    local has_session = session ~= nil

    local term_buf
    if not has_session and util.is_buf_valid(state.last_session_buf) then
        term_buf = state.last_session_buf
    else
        if views.cleanup_view(not has_session, "No active session") then
            return
        end

        ---@cast session dap.Session

        term_buf = M.fetch_term_buf(session)
        -- Do not allow switching to the root session from js-debug-adapter
        -- If that were shown, it could be misleading, since the top-level session does not have any control over the terminal
        -- i.e., the user would see a terminal but they wouldn't be able to step or control the flow from the parent session
        local should_hide = adapter.is_js_adapter(session.config.type) and session.parent == nil
        if
            views.cleanup_view(not util.is_buf_valid(term_buf) or should_hide, "No terminal for the current session")
        then
            return
        end
    end

    ---`cleanup_view` ensures the buffer exists
    ---@cast term_buf integer

    state.last_session_buf = term_buf

    local is_autoscrolling = scroll.is_autoscrolling(term_buf)

    api.nvim_win_call(state.winnr, function()
        vim.wo[state.winnr][0].winfixbuf = false
        api.nvim_set_current_buf(term_buf)
        vim.wo[state.winnr][0].winfixbuf = true
    end)

    winbar.refresh_winbar("console")

    -- Only apply window options for the console once we set the terminal
    require("dap-view.console.options").set_win_options(state.winnr)

    -- When showing a session for the first time, assume the user wants autoscroll to just work™
    -- That's necessary because when a terminal buffer is created, the number of lines is assigned to the number of
    -- lines in the window. This may lead to autoscroll being set to false, since the user may not be "at the bottom".
    if is_autoscrolling then
        scroll.scroll_to_bottom(state.winnr, term_buf)
    end
end

---Hide the term win, does not affect the term buffer
M.hide_term_buf_win = function()
    if util.is_win_valid(state.term_winnr) then
        api.nvim_win_hide(state.term_winnr)
    end
end

---Open the term buf in a new window if
---I. A session is active (with a corresponding term buf)
---II. The adapter isn't configured to be hidden
---III. There's no term win or it is invalid
---@return integer?
M.open_term_buf_win = function()
    local session = require("dap").session()

    if session == nil then
        -- There's no session, but there might a leftover terminal from the last session (#144)
        -- If that's the case we shouldn't open a new window, but retrieve this last one instead
        local win = require("dap-view.util.window").fetch_window({ current_tab = true, term = true })
        if win then
            return win
        end
    end

    -- Attempt to restore previous buffer even when there's no session (#147)
    local term_bufnr = (session and M.fetch_term_buf(session))
        or (util.is_buf_valid(state.last_session_buf) and state.last_session_buf)

    if not term_bufnr then
        return nil
    end

    local windows_config = setup.config.windows
    local term_config = setup.config.windows.terminal

    local hide_adapter = vim.tbl_contains(term_config.hide, state.current_adapter)

    if term_bufnr and not hide_adapter and not util.is_win_valid(state.term_winnr) then
        local is_win_valid = util.is_win_valid(state.winnr)

        local position = windows_config.position
        local win_pos = (type(position) == "function" and position(state.win_pos))
            or (type(position) == "string" and position)

        ---@cast win_pos dapview.Position

        state.win_pos = win_pos

        local term_position = term_config.position
        local term_win_pos = (type(term_position) == "function" and term_position(win_pos))
            or (type(term_position) == "string" and term_position)

        ---@cast term_win_pos dapview.Position

        local size_ = windows_config.size
        local size__ = (type(size_) == "function" and size_(win_pos)) or size_

        ---@cast size__ number

        local is_vertical = win_pos == "above" or win_pos == "below"

        local go_max = is_vertical and go.lines or go.columns

        local size = size__ < 1 and math.floor(go_max * size__) or size__

        local term_size_ = term_config.size
        local term_size__ = (type(term_size_) == "function" and term_size_(term_win_pos)) or term_size_

        ---@cast term_size__ number

        local term_is_vertical = term_win_pos == "above" or term_win_pos == "below"

        local shared_split = term_is_vertical == is_vertical

        local winfix_setting = is_vertical and "winfixheight" or "winfixwidth"

        -- Temporarily disable fixed size
        -- If the window exists, it's using the space of both
        if is_win_valid and shared_split then
            vim.wo[state.winnr][winfix_setting] = false

            -- `size` is already an integer at this point
            if term_size__ < 1 then
                term_size__ = term_size__ * size
            end
        end

        local term_go_max = term_is_vertical and go.lines or go.columns

        local term_size = math.floor(term_size__ < 1 and term_go_max * term_size__ or term_size__)

        local term_winnr = api.nvim_open_win(term_bufnr, false, {
            split = is_win_valid and term_win_pos or win_pos,
            win = is_win_valid and state.winnr or -1,
            -- If there is a valid main window, we just need to apply whatever the term config says
            -- Which means that we'd only set the height for vertical terms
            -- Else, we need to create the window as if it occupied the space of both windows
            -- Which means that, we'd only set the height if the main window is a vertical split
            height = (is_win_valid and (term_is_vertical and term_size or nil)) or (is_vertical and size or nil),
            -- Symmetric for width
            width = (is_win_valid and (not term_is_vertical and term_size or nil) or (not is_vertical and size or nil)),
        })

        -- Restore fixed size
        if is_win_valid and shared_split then
            vim.wo[state.winnr][winfix_setting] = true
        end

        -- Track the state of the last term win, so it can be closed later if becomes a leftover window
        if state.term_winnr and term_winnr ~= state.term_winnr then
            state.last_term_winnr = state.term_winnr
        end

        state.term_winnr = term_winnr

        vim.w[state.term_winnr].dapview_win_term = true

        require("dap-view.console.options").set_win_options(state.term_winnr)
    end

    return state.term_winnr
end

M.setup_term_buf = function()
    local session = dap.session()

    assert(session ~= nil, "has active session")

    local term_bufnr = M.fetch_term_buf(session)

    if term_bufnr == nil then
        return
    end

    -- We have to set the filetype for each term buf to avoid issues when calling switch_term_buf
    -- See https://github.com/igorlfs/nvim-dap-view/issues/69
    vim.bo[term_bufnr].filetype = "dap-view-term"

    if vim.tbl_contains(setup.config.winbar.sections, "console") then
        winbar.set_action_keymaps(term_bufnr)
    end

    require("dap-view.console.keymaps").set_keymaps(term_bufnr)

    scroll.setup_autoscroll(term_bufnr)
end

M.switch_term_buf = function()
    local has_console = vim.tbl_contains(setup.config.winbar.sections, "console")
    local winnr = (has_console and state.winnr) or state.term_winnr
    local is_console_active = state.current_section == "console"

    local session = dap.session()

    assert(session ~= nil, "has active session")

    local term_bufnr = M.fetch_term_buf(session)

    -- Users might wanna restore the term buf even after the session ends (#147)
    state.last_session_buf = term_bufnr

    if term_bufnr == nil then
        return
    end

    if util.is_win_valid(winnr) and (is_console_active or not has_console) then
        ---@cast winnr integer

        api.nvim_win_call(winnr, function()
            vim.wo[winnr][0].winfixbuf = false
            api.nvim_set_current_buf(term_bufnr)
            vim.wo[winnr][0].winfixbuf = true

            if is_console_active then
                winbar.refresh_winbar("console")
            end

            if is_console_active or not has_console then
                -- Reset window options since they only take effect for the current buffer
                -- When starting a new session, if the console view is already active,
                -- these settings wouldn't be applied otherwise
                -- (since we don't refresh the view by calling `show`)
                require("dap-view.console.options").set_win_options(winnr)
            end
        end)
    end
end

return M
