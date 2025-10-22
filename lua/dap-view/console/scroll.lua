local setup = require("dap-view.setup")
local util = require("dap-view.util")
local state = require("dap-view.state")

local M = {}

local api = vim.api

---@type table<integer,boolean>
local termbuf_is_autoscrolling = {}

-- Inspired by nvim-dap-ui
-- https://github.com/rcarriga/nvim-dap-ui/blob/73a26abf4941aa27da59820fd6b028ebcdbcf932/lua/dapui/elements/console.lua#L23-L46

---@param bufnr integer
M.setup_autoscroll = function(bufnr)
    termbuf_is_autoscrolling[bufnr] = true

    api.nvim_create_autocmd({ "InsertEnter", "CursorMoved" }, {
        buffer = bufnr,
        group = api.nvim_create_augroup("nvim-dap-view-scroll-" .. bufnr, {}),
        callback = function()
            local winnr = vim.tbl_contains(setup.config.winbar.sections, "console") and state.winnr or state.term_winnr

            if not util.is_win_valid(winnr) then
                return
            end

            ---@cast winnr integer
            local cursor = api.nvim_win_get_cursor(winnr)

            termbuf_is_autoscrolling[bufnr] = cursor[1] == api.nvim_buf_line_count(bufnr)
        end,
    })

    api.nvim_buf_attach(bufnr, false, {
        on_lines = function()
            local winnr = vim.tbl_contains(setup.config.winbar.sections, "console") and state.winnr or state.term_winnr

            if not util.is_win_valid(winnr) then
                return
            end

            ---@cast winnr integer
            if M.is_autoscrolling(bufnr) and vim.fn.mode() == "n" then
                api.nvim_win_call(winnr, function()
                    if api.nvim_get_current_buf() == bufnr then
                        -- Ensure the cursor movement happens in the main event loop
                        -- Otherwise the call may happen too early
                        M.scroll_to_bottom(winnr, bufnr)
                    end
                end)
            end
        end,
    })
end

---@param bufnr integer
---@return boolean?
M.is_autoscrolling = function(bufnr)
    return termbuf_is_autoscrolling[bufnr]
end

---@param winnr integer
---@param bufnr integer
M.scroll_to_bottom = function(winnr, bufnr)
    if util.is_win_valid(winnr) and util.is_buf_valid(bufnr) then
        vim.schedule(function()
            api.nvim_win_set_cursor(winnr, { api.nvim_buf_line_count(bufnr), 0 })
        end)

        termbuf_is_autoscrolling[bufnr] = true
    end
end

---@param bufnr integer
M.cleanup_autoscroll = function(bufnr)
    if termbuf_is_autoscrolling[bufnr] then
        api.nvim_del_augroup_by_name("nvim-dap-view-scroll-" .. bufnr)

        termbuf_is_autoscrolling[bufnr] = nil
    end
end

return M
