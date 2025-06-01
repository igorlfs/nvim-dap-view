local dap = require("dap")

local state = require("dap-view.state")
local setup = require("dap-view.setup")
local util = require("dap-view.util")

local M = {}

local api = vim.api

---Hide the term win, does not affect the term buffer
M.hide_term_buf_win = function()
    if util.is_win_valid(state.term_winnr) then
        api.nvim_win_hide(state.term_winnr)
    end
end

---Open the term buf in a new window if
---I. A session is active
---II. There's term term buf
---III. The adapter isn't configured to be hidden
---IV. There's no term win or it is invalid
---@return integer?
M.open_term_buf_win = function()
    local windows_config = setup.config.windows
    local term_config = setup.config.windows.terminal
    local should_term_be_hidden = vim.tbl_contains(term_config.hide, state.current_adapter)

    if not state.current_session_id then
        return nil
    end
    local term_bufnr = state.term_bufnrs[state.current_session_id]

    if term_bufnr and not should_term_be_hidden then
        if not state.term_winnr or state.term_winnr and not api.nvim_win_is_valid(state.term_winnr) then
            local is_win_valid = state.winnr ~= nil and api.nvim_win_is_valid(state.winnr)

            state.term_winnr = api.nvim_open_win(term_bufnr, false, {
                split = is_win_valid and term_config.position or windows_config.position,
                win = is_win_valid and state.winnr or -1,
                height = windows_config.height < 1 and math.floor(vim.go.lines * windows_config.height)
                    or windows_config.height,
                width = term_config.width < 1 and math.floor(vim.go.columns * term_config.width)
                    or term_config.width,
            })

            require("dap-view.term.options").set_options(state.term_winnr, term_bufnr)
        end
    end

    return state.term_winnr
end

---Create the term buf and setup nvim-dap's
M.setup_term_win_cmd = function()
    -- Can't use an unlisted term buffers
    -- See https://github.com/igorlfs/nvim-dap-view/pull/37#issuecomment-2785076872

    local session = dap.session()
    if session then
        state.current_session_id = session.id
    end

    if not state.current_session_id and not state.fallback_term_bufnr then
        state.fallback_term_bufnr = api.nvim_create_buf(true, false)

        return state.fallback_term_bufnr
    end

    local term_bufnr = state.term_bufnrs[state.current_session_id]

    if not term_bufnr then
        term_bufnr = api.nvim_create_buf(true, false)

        state.term_bufnrs[state.current_session_id] = term_bufnr
    end

    return term_bufnr
end

return M
