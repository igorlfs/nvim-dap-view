local dap = require("dap")

local state = require("dap-view.state")
local autocmd = require("dap-view.options.autocmd")
local setup = require("dap-view.setup")
local options = require("dap-view.term.options")

local M = {}

local api = vim.api

--- @param session dap.Session
--- @return integer
M.get_term_buf = function(session)
    local bufnr = state.term_bufnrs[session.id]
    return bufnr
end

--- @param session dap.Session
M.new_term_buf = function(session)
    local bufnr = vim.api.nvim_create_buf(true, false)
    state.term_bufnrs[session.id] = bufnr
    return bufnr
end

---Hide the term win, does not affect the term buffer
M.hide_term_buf_win = function()
    if state.term_winnr and api.nvim_win_is_valid(state.term_winnr) then
        api.nvim_win_hide(state.term_winnr)
    end
end

M.term_win_is_valid = function()
    -- if not state.term_winnr or state.term_winnr and not api.nvim_win_is_valid(state.term_winnr) then
    return state.term_winnr and api.nvim_win_is_valid(state.term_winnr)
end

M.force_delete_term_buf = function()
    -- TODO: temporarily commented this out
    -- if state.term_bufnr then
    --     api.nvim_buf_delete(state.term_bufnr, { force = true })
    -- end
end

---Open the term buf in a new window if
---I. A session is active
---II. The term buf exists
---III. The adapter isn't configured to be hidden
---IV. There's no term win or it is invalid
---@return integer?
M.open_term_buf_win = function()
    local term_config = setup.config.windows.terminal
    local should_term_be_hidden = vim.tbl_contains(term_config.hide, state.last_active_adapter)

    local session = dap.session()
    if session == nil then
        vim.notify("term.open_term_buf_win: no session")
        return
    end

    vim.notify("term.open_term_buf_win: session " .. session.id)

    local is_new = false
    local termbuf = M.get_term_buf(session)

    if not termbuf then
        vim.notify("creating new termbuf")
        is_new = true
        termbuf = M.new_term_buf(session)
    end

    if not M.term_win_is_valid() then
        local is_win_valid = state.winnr ~= nil and api.nvim_win_is_valid(state.winnr)
        vim.notify("creating new term win. is_win_valid = " .. vim.inspect(is_win_valid))

        state.term_winnr = api.nvim_open_win(termbuf, false, {
            split = is_win_valid and term_config.position or "below",
            win = is_win_valid and state.winnr or -1,
            height = setup.config.windows.height,
            width = term_config.width < 1 and math.floor(vim.o.columns * term_config.width)
                or term_config.width,
        })
    else
        M.update_term_buf_session(session)
    end

    if is_new then
        options.set_options(state.term_winnr, termbuf)
    end

    return state.term_winnr
end

--- @param session dap.Session
M.update_term_buf_session = function(session)
    if not M.term_win_is_valid() then
        vim.notify("term.update_term_buf_session: term win not valid, stopping")
        return
    end

    local termbuf = M.get_term_buf(session)
    if not termbuf then
        vim.notify("term.update_term_buf_session: termbuf not valid, stopping")
        return
    end

    vim.notify("term.update_term_buf_session")
    api.nvim_win_set_buf(state.term_winnr, termbuf)
end

return M
