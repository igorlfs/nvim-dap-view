local dap = require("dap")

local widgets = require("dap.ui.widgets")

local views = require("dap-view.views")
local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")

local M = {}

local api = vim.api

local scopes_widget

local last_scopes_bufnr

local new_widget = function()
    return widgets
        .builder(widgets.scopes)
        .new_buf(function()
            return state.bufnr
        end)
        .new_win(function()
            return state.winnr
        end)
        .build()
end

M.show = function()
    winbar.update_section("scopes")

    if views.cleanup_view(not dap.session(), "No active session") then
        return
    end

    if last_scopes_bufnr == nil or last_scopes_bufnr ~= state.bufnr then
        scopes_widget = new_widget()
        last_scopes_bufnr = state.bufnr
    end

    scopes_widget.open()

    local lnum_count = api.nvim_buf_line_count(state.bufnr)

    views.cleanup_view(lnum_count == 1, "Debug adapter returned no scopes")
end

M.refresh = function()
    if last_scopes_bufnr == nil or last_scopes_bufnr ~= state.bufnr then
        scopes_widget = new_widget()

        last_scopes_bufnr = state.bufnr

        scopes_widget.open()
    else
        scopes_widget.refresh()
    end
end

return M
