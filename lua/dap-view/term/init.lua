local dap = require("dap")

local state = require("dap-view.state")
local autocmd = require("dap-view.options.autocmd")
local setup = require("dap-view.setup")

local M = {}

local api = vim.api

--- @param session dap.Session
--- @return integer
M.get_session_buf = function(session)
    local bufnr = state.term_bufnrs[session.id]

    if bufnr == nil then
        bufnr = vim.api.nvim_create_buf(true, false)
        state.term_bufnrs[session.id] = bufnr
    end

    return bufnr
end

---Hide the term win, does not affect the term buffer
M.hide_term_buf_win = function()
    if state.term_winnr and api.nvim_win_is_valid(state.term_winnr) then
        api.nvim_win_hide(state.term_winnr)
    end
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
    vim.notify("term.open_term_buf_win")

    local term_config = setup.config.windows.terminal
    local should_term_be_hidden = vim.tbl_contains(term_config.hide, state.last_active_adapter)

    local session = dap.session()
    if session == nil then
        vim.notify("term.open_term_buf_win: no session")
        return
    end

    local termbuf = M.get_session_buf(session)

    if termbuf and not should_term_be_hidden then
        if not state.term_winnr or state.term_winnr and not api.nvim_win_is_valid(state.term_winnr) then
            local is_win_valid = state.winnr ~= nil and api.nvim_win_is_valid(state.winnr)

            state.term_winnr = api.nvim_open_win(termbuf, false, {
                split = is_win_valid and term_config.position or "below",
                win = is_win_valid and state.winnr or -1,
                height = setup.config.windows.height,
                width = term_config.width < 1 and math.floor(vim.o.columns * term_config.width)
                    or term_config.width,
            })

            require("dap-view.term.options").set_options(state.term_winnr, termbuf)
        else
            M.update_term_buf_session(session)
        end
    end

    return state.term_winnr
end

--- @param session dap.Session
M.update_term_buf_session = function(session)
    local termbuf = M.get_session_buf(session)
    api.nvim_win_set_buf(state.term_winnr, termbuf)
end

---Create the term buf and setup nvim-dap's `terminal_win_cmd` to use it
M.setup = function()
    -- setup terminal_win_cmd to return the correct terminal buffer
    dap.defaults.fallback.terminal_win_cmd = function(config)
        vim.notify("terminal_win_cmd")
        local session = dap.session()
        assert(session ~= nil, "session is nil, but asking for a terminal?")

        vim.notify(vim.inspect(session.id))
        return M.get_session_buf(session)
        -- local term_bufnr = api.nvim_create_buf(true, false)
        -- -- assert(state.term_bufnr ~= 0, "Failed to create nvim-dap-view buffer")
        -- -- autocmd.quit_buf_autocmd(state.term_bufnr, quit_term_buf)
        --
        -- vim.notify("(dap) terminal_win_cmd: " .. term_bufnr)
        -- return term_bufnr
    end

    -- wrap dap.set_session so we're "alerted" when the session changes
    local wrapped_set_session = function(orig_set_session)
        ---@param new_session dap.Session|nil
        return function(new_session)
            orig_set_session(new_session)
            local _session = dap.session()
            if _session ~= nil then
                M.update_term_buf_session(_session)

                -- horrid
                local current_section = state.current_section
                if current_section ~= nil then
                    require("dap-view." .. current_section .. ".view").show()
                end
            end
        end
    end

    dap.set_session = wrapped_set_session(dap.set_session)
end

return M
