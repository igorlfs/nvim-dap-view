local dap = require("dap")
local term = require("dap-view.term")
local state = require("dap-view.state")

local M = {}

M.prepare = function()
    M.set_terminal_win_cmd()
    M.disable_dap_termbuf_pooling()
    M.register_on_session_changed_handler()
end

M.set_terminal_win_cmd = function()
    dap.defaults.fallback.terminal_win_cmd = function(config)
        vim.notify("terminal_win_cmd")
        local session = dap.session()
        assert(session, "no session, but asking for a terminal?")

        vim.notify(vim.inspect(session.id))
        local bufnr = term.get_term_buf(session)
        assert(bufnr, "no bufnr associated with session")
        return bufnr

        -- local term_bufnr = api.nvim_create_buf(true, false)
        -- -- assert(state.term_bufnr ~= 0, "Failed to create nvim-dap-view buffer")
        -- -- autocmd.quit_buf_autocmd(state.term_bufnr, quit_term_buf)
        --
        -- vim.notify("(dap) terminal_win_cmd: " .. term_bufnr)
        -- return term_bufnr
    end
end

M.disable_dap_termbuf_pooling = function()
    require("dap.session").termbuf_pooling_disable()
end

local previous_session_id = nil

--- param session dap.Session
local on_new_session = function(session)
    term.update_term_buf_session(session)

    local current_section = state.current_section

    if current_section == "breakpoints" then
        require("dap-view.breakpoints.view").show()
    elseif current_section == "exceptions" then
        require("dap-view.exceptions.view").show()
    elseif current_section == "breakpoints" then
        require("dap-view.breakpoints.view").show()
    elseif current_section == "watches" then
        require("dap-view.watches.view").show()
    elseif current_section == "repl" then
        require("dap-view.repl.view").show()
    elseif current_section == "threads" then
        require("dap-view.threads.view").show()
    elseif current_section == "console" then
        require("dap-view.console.view").show()
    elseif current_section == "scopes" then
        require("dap-view.scopes.view").show()
    end
end

-- called when dap.session() is nil after not being so
local no_session = function()

end

M.register_on_session_changed_handler = function()
    dap.register_on_session_changed_handler(function(session)
        local has_previous_session_id = previous_session_id ~= nil
        local sessions_cleared = session == nil and has_previous_session_id
        local is_new_session = session ~= nil and (not has_previous_session_id or previous_session_id ~= session.id)

        if sessions_cleared then
            no_session()
            previous_session_id = nil
        elseif is_new_session then
            on_new_session(session)
            previous_session_id = session.id
        end
    end)
end

return M
