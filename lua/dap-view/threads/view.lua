local dap = require("dap")

local winbar = require("dap-view.options.winbar")
local views = require("dap-view.views")
local state = require("dap-view.state")

local M = {}

local api = vim.api

M.show = function()
    winbar.update_winbar("threads")

    if state.bufnr then
        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

        if views.cleanup_view(not dap.session(), "No active session") then
            return
        end

        if state.threads_err then
            api.nvim_buf_set_lines(state.bufnr, 0, -1, false, { "Failed to get threads", state.threads_err })
            return
        end

        if views.cleanup_view(vim.tbl_isempty(state.threads), "Debug adapter returned no threads") then
            return
        end

        local content = vim
            .iter(state.threads)
            ---@param t dap.Thread
            :map(function(t)
                return t.name
            end)
            :totable()

        api.nvim_buf_set_lines(state.bufnr, 0, -1, false, content)
    end
end

return M
