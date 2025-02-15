local dap = require("dap")

local state = require("dap-view.state")
local config = require("dap-view.setup").config
local util_buf = require("dap-view.util.buffer")

local api = vim.api

local M = {
    state = {
        ---@type integer?
        winnr = nil,
        ---@type integer?
        bufnr = nil,
    },
}

---@param callback? fun(): nil
M.create_term_buf = function(callback)
    if not M.state.bufnr then
        M.state.bufnr = api.nvim_create_buf(true, false)

        assert(M.state.bufnr ~= 0, "Failed to create nvim-dap-view buffer")

        util_buf.quit_buf_autocmd(M.state.bufnr, M.reset_term_buf)

        if callback then
            callback()
        end
    end
end

M.hide_term_buf = function()
    if M.state.winnr and api.nvim_win_is_valid(M.state.winnr) then
        api.nvim_win_hide(M.state.winnr)
    end
end

M.delete_term_buf = function()
    if M.state.bufnr then
        api.nvim_buf_delete(M.state.bufnr, { force = true })
        M.state.bufnr = nil
    end
end

M.reset_term_buf = function()
    -- Only reset the buffer if there's no active session
    if M.state.bufnr and not (config.windows.terminal.ignore_session or dap.session()) then
        M.state.bufnr = nil
    end
end

---@return integer?
M.open_term_buf_win = function()
    M.create_term_buf()

    local is_term_hidden = vim.tbl_contains(config.windows.terminal.hide, state.last_active_adapter)
    local ignore_session = config.windows.terminal.ignore_session
    if (ignore_session or dap.session()) and M.state.bufnr and not is_term_hidden then
        if M.state.winnr == nil or M.state.winnr and not api.nvim_win_is_valid(M.state.winnr) then
            local is_win_valid = M.state.winnr ~= nil and api.nvim_win_is_valid(M.state.winnr)

            local position = config.windows.terminal.position
            M.state.winnr = api.nvim_open_win(M.state.bufnr, false, {
                split = is_win_valid
                        and (ignore_session and (position == "left" and "right" or "left") or position)
                    or "below",
                win = is_win_valid and M.state.winnr or -1,
                height = config.windows.height,
            })

            require("dap-view.term.options").set_options(M.state.winnr, M.state.bufnr)
        end
    end

    return M.state.winnr
end

M.setup_term = function()
    M.create_term_buf(function()
        dap.defaults.fallback.terminal_win_cmd = function()
            assert(M.state.bufnr, "Failed to get term bufnr")

            return M.state.bufnr
        end
    end)
end

return M
