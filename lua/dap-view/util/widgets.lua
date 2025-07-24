local M = {}

local widgets = require("dap.ui.widgets")

---@param bufnr integer
---@param winnr integer
---@param widget dap.ui.Widget
M.new_widget = function(bufnr, winnr, widget)
    return widgets
        .builder(widget)
        .new_buf(function()
            return bufnr
        end)
        .new_win(function()
            return winnr
        end)
        .build()
end

return M
