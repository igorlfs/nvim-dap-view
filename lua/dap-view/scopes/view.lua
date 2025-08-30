local dap = require("dap")
local dap_widgets = require("dap.ui.widgets")

local views = require("dap-view.views")
local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")
local widgets = require("dap-view.util.widgets")

local M = {}

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

    local session = dap.session()
    if views.cleanup_view(not session, "No active session") then
        return
    end

    ---@cast session dap.Session

    local has_scopes = session.current_frame and session.current_frame.scopes and #session.current_frame.scopes > 0

    -- We can't count the number of lines here because the widget might not have refreshed yet,
    -- so we resort to looking at the scopes directly
    views.cleanup_view(not has_scopes, "Debug adapter returned no scopes")
end

M.show = function()
    winbar.refresh_winbar("scopes")

    launch_and_refresh_widget()
end

M.refresh = launch_and_refresh_widget

return M
