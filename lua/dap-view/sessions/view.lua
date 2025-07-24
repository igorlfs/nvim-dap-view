local dap = require("dap")
local dap_widgets = require("dap.ui.widgets")

local views = require("dap-view.views")
local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")
local widgets = require("dap-view.util.widgets")

local M = {}

local sessions_widget

local last_sessions_bufnr

local build_widget = function()
    return widgets.new_widget(state.bufnr, state.winnr, dap_widgets.sessions)
end

M.show = function()
    winbar.refresh_winbar("sessions")

    if views.cleanup_view(not dap.session(), "No active session") then
        return
    end

    if last_sessions_bufnr == nil or last_sessions_bufnr ~= state.bufnr then
        sessions_widget = build_widget()
        last_sessions_bufnr = state.bufnr
    end

    assert(sessions_widget, "Session widget exists")

    sessions_widget.open()
end

M.refresh = function()
    if last_sessions_bufnr == nil or last_sessions_bufnr ~= state.bufnr then
        sessions_widget = build_widget()

        last_sessions_bufnr = state.bufnr

        sessions_widget.open()
    elseif sessions_widget then
        sessions_widget.refresh()
    else
        vim.notify("Error refreshing sessions widget, open a bug report")
    end
end

return M
