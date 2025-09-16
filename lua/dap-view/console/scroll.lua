local setup = require("dap-view.setup")
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
        callback = function()
            local winnr = vim.tbl_contains(setup.config.winbar.sections, "console") and state.winnr or state.term_winnr
            if util.is_win_valid(winnr) then
                ---@cast winnr integer
                local cursor = api.nvim_win_get_cursor(winnr)
                autoscroll = cursor[1] == api.nvim_buf_line_count(bufnr)
            end
        end,
    })

    api.nvim_buf_attach(bufnr, false, {
        on_lines = function()
            local winnr = vim.tbl_contains(setup.config.winbar.sections, "console") and state.winnr or state.term_winnr
            if not util.is_win_valid(winnr) then
                return
            end
            ---@cast winnr integer
            if autoscroll and vim.fn.mode() == "n" then
                api.nvim_win_call(winnr, function()
                    if api.nvim_get_current_buf() == bufnr then
                        -- vim.schedule ensures the cursor movement happens in the main event loop
                        -- otherwise the call may happen too early
                        vim.schedule(function()
                            api.nvim_win_set_cursor(winnr, { api.nvim_buf_line_count(bufnr), 0 })
                        end)
                    end
                end)
            end
        end,
    })
end

return M
