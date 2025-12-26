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

    if views.cleanup_view(session == nil, "No active session") then
        return
    end

    assert(session ~= nil, "has active session")

    local term_buf = M.fetch_term_buf(session)
    -- Do not allow switching to the root session from js-debug-adapter
    -- If that were shown, it could be misleading, since the top-level session does not have any control over the terminal
    -- i.e., the user would see a terminal but they wouldn't be able to step or control the flow from the parent session
    local should_hide = adapter.is_js_adapter(session.config.type) and session.parent == nil
    if views.cleanup_view(not util.is_buf_valid(term_buf) or should_hide, "No terminal for the current session") then
        return
    end

    ---`cleanup_view` ensures the buffer exists
    ---@cast term_buf integer

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
        return nil
    end

    local term_bufnr = M.fetch_term_buf(session)

    if term_bufnr == nil then
        return nil
    end

    local windows_config = setup.config.windows
    local term_config = setup.config.windows.terminal

    local hide_adapter = vim.tbl_contains(term_config.hide, state.current_adapter)

    if term_bufnr and not hide_adapter and not util.is_win_valid(state.term_winnr) then
        local is_win_valid = util.is_win_valid(state.winnr)

        local position = windows_config.position
        local win_pos = (type(position) == "function" and position()) or (type(position) == "string" and position)

        ---@cast win_pos dapview.Position

        local term_position = term_config.position
        local term_win_pos = (type(term_position) == "function" and term_position(win_pos))
            or (type(term_position) == "string" and term_position)

        ---@cast term_win_pos dapview.Position

        local term_winnr = api.nvim_open_win(term_bufnr, false, {
            split = is_win_valid and term_win_pos or win_pos,
            win = is_win_valid and state.winnr or -1,
            height = windows_config.height < 1 and math.floor(vim.go.lines * windows_config.height)
                or windows_config.height,
            width = term_config.width < 1 and math.floor(vim.go.columns * term_config.width) or term_config.width,
        })

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
