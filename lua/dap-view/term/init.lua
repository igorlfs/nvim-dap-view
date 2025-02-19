local dap = require("dap")

local state = require("dap-view.state")
local setup = require("dap-view.setup")
local util_buf = require("dap-view.util.buffer")

local api = vim.api

local M = {}

---@param callback? fun(): nil
M.create_term_buf = function(callback)
    if not state.term_bufnr then
        state.term_bufnr = api.nvim_create_buf(true, false)

        assert(state.term_bufnr ~= 0, "Failed to create nvim-dap-view buffer")

        util_buf.quit_buf_autocmd(state.term_bufnr, M.reset_term_buf)

        if callback then
            callback()
        end
    end
end

M.hide_term_buf = function()
    if state.term_winnr and api.nvim_win_is_valid(state.term_winnr) then
        api.nvim_win_hide(state.term_winnr)
    end
end

M.delete_term_buf = function()
    if state.term_bufnr then
        api.nvim_buf_delete(state.term_bufnr, { force = true })
        state.term_bufnr = nil
    end
end

M.reset_term_buf = function()
    if state.term_bufnr and not dap.session() then
        state.term_bufnr = nil
    end
end

---@return integer?
M.open_term_buf_win = function()
    M.create_term_buf()

    if state.should_create_terminal() then
        state.term_winnr = api.nvim_open_win(state.term_bufnr, false, state.get_term_window_config())

        require("dap-view.term.options").set_options(state.term_winnr, state.term_bufnr)
    end

    return state.term_winnr
end

M.setup_term = function()
    M.create_term_buf(function()
        dap.defaults.fallback.terminal_win_cmd = function()
            assert(state.term_bufnr, "Failed to get term bufnr")

            return state.term_bufnr
        end
    end)
end

return M
