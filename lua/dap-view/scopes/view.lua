local dap = require("dap")
local dap_widgets = require("dap.ui.widgets")

local views = require("dap-view.views")
local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")
local widgets = require("dap-view.util.widgets")

local M = {}

local api = vim.api

local scopes_widget

local last_scopes_bufnr

local launch_and_refresh_widget = function()
    if last_scopes_bufnr == nil or last_scopes_bufnr ~= state.bufnr then
        scopes_widget = widgets.new_widget(state.bufnr, state.winnr, dap_widgets.scopes)
        last_scopes_bufnr = state.bufnr

        scopes_widget.open()
    end

    -- Always refresh, otherwise outdated information may be shown
    scopes_widget.refresh()
end

M.show = function()
    winbar.refresh_winbar("scopes")

    if views.cleanup_view(not dap.session(), "No active session") then
        return
    end

    launch_and_refresh_widget()

    local lnum_count = api.nvim_buf_line_count(state.bufnr)

    views.cleanup_view(lnum_count == 1, "Debug adapter returned no scopes")
end

M.refresh = launch_and_refresh_widget

return M
