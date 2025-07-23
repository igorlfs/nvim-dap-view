local dap = require("dap")
local base_buttons = require("dap-view.options.controls.base")

local statusline = require("dap-view.util.statusline")
local setup = require("dap-view.setup")
local module = ...

local M = {}

---@param idx integer
---@param clicks integer
---@param button '"l"' | '"r"' | '"m"'
---@param modifiers string
M.on_click = function(idx, clicks, button, modifiers)
    local config = setup.config.winbar.controls
    local key = config.buttons[idx]
    local control = config.custom_buttons[key] or base_buttons[key]
    control.action(clicks, button, modifiers)
end

---@return string
M.render = function()
    local config = setup.config.winbar.controls
    local bar = ""
    local session = dap.session()
    for idx, key in ipairs(config.buttons) do
        local control = config.custom_buttons[key] or base_buttons[key]
        local icon = " " .. control.render(session) .. " "
        bar = bar .. statusline.clickable(icon, module, "on_click", idx)
    end
    return bar
end

return M
