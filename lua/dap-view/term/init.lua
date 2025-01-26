local dap = require("dap")

local state = require("dap-view.state")
local setup = require("dap-view.setup")
local util_buf = require("dap-view.util.buffer")

local api = vim.api

local M = {}

---@type integer?
local term_winnr = nil
---@type integer?
local term_bufnr = nil

M.clear_term_bufnr = function()
    if term_bufnr then
        api.nvim_buf_delete(term_bufnr, { force = true })
        term_bufnr = nil
    end
end

M.close_term_buf_win = function()
    if term_winnr and api.nvim_win_is_valid(term_winnr) then
        api.nvim_win_close(term_winnr, true)
        term_winnr = nil
    end
    -- Only delete the buffer if there's no active session
    if term_bufnr and not dap.session() then
        api.nvim_buf_delete(term_bufnr, { force = true })
        term_bufnr = nil
    end
end

---@return integer?
M.open_term_buf_win = function()
    -- When (re)opening the terminal we should NOT close it,
    -- since it's the default standard output for most adapters
    -- Therefore, closing it could delete useful information from past sessions

    if term_bufnr == nil then
        term_bufnr = api.nvim_create_buf(true, false)

        assert(term_bufnr ~= 0, "Failed to create nvim-dap-view buffer")

        util_buf.quit_buf_autocmd(term_bufnr, M.close_term_buf_win)
    end

    local config = setup.config

    if term_winnr == nil then
        for _, adapter in ipairs(config.terminal.exclude_adapters) do
            dap.defaults[adapter].terminal_win_cmd = function(session)
                state.last_active_adapter = session.type

                return term_bufnr
            end
        end

        dap.defaults.fallback.terminal_win_cmd = function(session)
            state.last_active_adapter = session.type

            local is_win_valid = state.winnr ~= nil and api.nvim_win_is_valid(state.winnr) or false
            term_winnr = api.nvim_open_win(term_bufnr, false, {
                split = is_win_valid and "left" or "below",
                win = is_win_valid and state.winnr or -1,
                height = config.windows.height,
            })

            assert(term_winnr ~= 0, "Failed to create nvim-dap-view terminal window")

            require("dap-view.term.options").set_options(term_winnr, term_bufnr)

            return term_bufnr, term_winnr
        end
    end

    return term_winnr
end

return M
