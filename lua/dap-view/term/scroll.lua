local util = require("dap-view.util")
local state = require("dap-view.state")

local M = {}

local api = vim.api

local autoscroll = true

-- Inspired by nvim-dap-ui
-- https://github.com/rcarriga/nvim-dap-ui/blob/73a26abf4941aa27da59820fd6b028ebcdbcf932/lua/dapui/elements/console.lua#L23-L46

---@param bufnr integer
M.scroll = function(bufnr)
    api.nvim_create_autocmd({ "InsertEnter", "CursorMoved" }, {
        buffer = bufnr,
        callback = function(args)
            if args.buf == bufnr then
                local cursor = api.nvim_win_get_cursor(0)
                autoscroll = cursor[1] == api.nvim_buf_line_count(bufnr)
            end
        end,
    })

    api.nvim_buf_attach(bufnr, false, {
        on_lines = function()
            if not util.is_win_valid(state.term_winnr) then
                return
            end
            if autoscroll and vim.fn.mode() == "n" then
                api.nvim_win_call(state.term_winnr, function()
                    if api.nvim_get_current_buf() == bufnr then
                        api.nvim_win_set_cursor(state.term_winnr, { api.nvim_buf_line_count(bufnr), 1 })
                    end
                end)
            end
        end,
    })
end

return M
