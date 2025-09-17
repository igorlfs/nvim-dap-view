local setup = require("dap-view.setup")
local util = require("dap-view.util")
local state = require("dap-view.state")

local M = {}

local api = vim.api
local termbuf_is_autoscrolling = {}

-- Inspired by nvim-dap-ui
-- https://github.com/rcarriga/nvim-dap-ui/blob/73a26abf4941aa27da59820fd6b028ebcdbcf932/lua/dapui/elements/console.lua#L23-L46

---@return integer?
M.get_winnr = function()
    local winnr = vim.tbl_contains(setup.config.winbar.sections, "console") and state.winnr or state.term_winnr

    if not util.is_win_valid(winnr) then
        return nil
    end

    return winnr
end

---@param bufnr integer
M.setup_autoscroll = function(bufnr)
    termbuf_is_autoscrolling[bufnr] = true

    -- BUG: since term buffers seem to be re-used for restarted sessions
    -- this autocmd gets recreated for each restart
    api.nvim_create_autocmd({ "InsertEnter", "CursorMoved" }, {
        buffer = bufnr,
        callback = function(args)
            local winnr = M.get_winnr()
            if winnr == nil then
                return
            end

            ---@cast winnr integer
            local cursor = api.nvim_win_get_cursor(winnr)
            termbuf_is_autoscrolling[bufnr] = cursor[1] == api.nvim_buf_line_count(bufnr)

            vim.notify(vim.inspect({
                args.event,
                cursor[1],
                api.nvim_buf_line_count(bufnr),
                termbuf_is_autoscrolling[bufnr],
            }))
        end,
    })

    api.nvim_buf_attach(bufnr, false, {
        on_lines = function()
            local winnr = M.get_winnr()
            if winnr == nil then
                return
            end

            ---@cast winnr integer
            if M.is_autoscrolling(bufnr) and vim.fn.mode() == "n" then
                api.nvim_win_call(winnr, function()
                    if api.nvim_get_current_buf() == bufnr then
                        M.set_cursor_bottom(winnr, bufnr)
                    end
                end)
            end
        end,
    })
end

M.is_autoscrolling = function(bufnr)
    return termbuf_is_autoscrolling[bufnr]
end

M.set_cursor_bottom = function(winnr, bufnr)
    -- vim.schedule ensures the cursor movement happens in the main event loop
    -- otherwise the call may happen too early
    vim.schedule(function()
        api.nvim_win_set_cursor(winnr, { api.nvim_buf_line_count(bufnr), 0 })
        termbuf_is_autoscrolling[bufnr] = true
    end)
end

-- NOTE: not sure where this should be called - is an autocmd necessary for this?
---@param bufnr integer
M.cleanup_autoscroll = function(bufnr)
    table.remove(termbuf_is_autoscrolling, bufnr)
end

return M
