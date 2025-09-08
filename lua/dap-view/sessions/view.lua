local dap = require("dap")
local dap_widgets = require("dap.ui.widgets")

local views = require("dap-view.views")
local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")
local util = require("dap-view.util")
local widgets = require("dap-view.util.widgets")

local M = {}

local sessions_widget

local last_sessions_bufnr

local launch_and_refresh_widget = function()
    if last_sessions_bufnr == nil or last_sessions_bufnr ~= state.bufnr then
        sessions_widget = widgets.new_widget(state.bufnr, state.winnr, dap_widgets.sessions)
        last_sessions_bufnr = state.bufnr

        sessions_widget.open()
    end

    if not util.is_win_valid(state.winnr) then
        return
    end

    sessions_widget.refresh()

    views.cleanup_view(not dap.session(), "No active session")
end

M.show = function()
    winbar.refresh_winbar("sessions")

    launch_and_refresh_widget()
end

M.refresh = launch_and_refresh_widget

return M
