local dap = require("dap")

local widgets = require("dap.ui.widgets")

local views = require("dap-view.views")
local winbar = require("dap-view.options.winbar")
local state = require("dap-view.state")

local M = {}

local scopes_widget

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
    winbar.update_winbar("scopes")

    if views.cleanup_view(not dap.session(), "No active session") then
        return
    end

    if scopes_widget == nil then
        scopes_widget = new_widget()
    end

    scopes_widget.open()
end

M.refresh = function()
    if scopes_widget == nil then
        scopes_widget = new_widget()

        scopes_widget.open()
    else
        scopes_widget.refresh()
    end
end

return M
