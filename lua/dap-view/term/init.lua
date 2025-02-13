local dap = require("dap")

local state = require("dap-view.state")
local config = require("dap-view.setup").config
local util_buf = require("dap-view.util.buffer")

local api = vim.api

local M = {}

---@type integer?
local term_winnr = nil
---@type integer?
local term_bufnr = nil

---@param callback? fun(): nil
local create_term_buf = function(callback)
    if not term_bufnr then
        term_bufnr = api.nvim_create_buf(true, false)

        assert(term_bufnr ~= 0, "Failed to create nvim-dap-view buffer")

        util_buf.quit_buf_autocmd(term_bufnr, M.reset_term_buf)

        if callback then
            callback()
        end
    end
end

M.hide_term_buf = function()
    if term_winnr and api.nvim_win_is_valid(term_winnr) then
        api.nvim_win_hide(term_winnr)
    end
end

M.delete_term_buf = function()
    if term_bufnr then
        api.nvim_buf_delete(term_bufnr, { force = true })
        term_bufnr = nil
    end
end

M.reset_term_buf = function()
    -- Only reset the buffer if there's no active session
    if term_bufnr and not dap.session() then
        term_bufnr = nil
    end
end

---@return integer?
M.open_term_buf_win = function()
    create_term_buf()

    local is_term_hidden = vim.tbl_contains(config.windows.terminal.hide, state.last_active_adapter)
    if dap.session() and term_bufnr and not is_term_hidden then
        if term_winnr == nil or term_winnr and not api.nvim_win_is_valid(term_winnr) then
            local is_win_valid = state.winnr ~= nil and api.nvim_win_is_valid(state.winnr)

            term_winnr = api.nvim_open_win(term_bufnr, false, {
                split = is_win_valid and "left" or "below",
                win = is_win_valid and state.winnr or -1,
                height = config.windows.height,
            })

            require("dap-view.term.options").set_options(term_winnr, term_bufnr)
        end
    end

    return term_winnr
end

M.setup_term = function()
    create_term_buf(function()
        dap.defaults.fallback.terminal_win_cmd = function()
            assert(term_bufnr, "Failed to get term bufnr")

            return term_bufnr
        end
    end)
end

return M
