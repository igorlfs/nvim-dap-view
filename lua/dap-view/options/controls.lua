local dap = require("dap")

local statusline = require("dap-view.util.statusline")
local setup = require("dap-view.setup")
local module = ...

local M = {}

---@type table<DefaultButton, ControlButton>
local buttons = {
    play = {
        render = function()
            local session = dap.session()
            if not session or session.stopped_thread_id then
                return statusline.hl(setup.config.winbar.controls.icons.play, "ControlPlay")
            else
                return statusline.hl(setup.config.winbar.controls.icons.pause, "ControlPause")
            end
        end,
        action = function()
            local session = dap.session()
            if not session or session.stopped_thread_id then
                dap.continue()
            else
                dap.pause()
            end
        end,
    },
    step_into = {
        render = function()
            local session = dap.session()
            local active = session and session.stopped_thread_id
            local hl = active and "ControlStepInto" or "ControlNC"
            return statusline.hl(setup.config.winbar.controls.icons.step_into, hl)
        end,
        action = function()
            dap.step_into()
        end,
    },
    step_over = {
        render = function()
            local session = dap.session()
            local active = session and session.stopped_thread_id
            local hl = active and "ControlStepOver" or "ControlNC"
            return statusline.hl(setup.config.winbar.controls.icons.step_over, hl)
        end,
        action = function()
            dap.step_over()
        end,
    },
    step_out = {
        render = function()
            local session = dap.session()
            local active = session and session.stopped_thread_id
            local hl = active and "ControlStepOut" or "ControlNC"
            return statusline.hl(setup.config.winbar.controls.icons.step_out, hl)
        end,
        action = function()
            dap.step_out()
        end,
    },
    step_back = {
        render = function()
            local session = dap.session()
            local active = session and session.stopped_thread_id
            local hl = active and "ControlStepBack" or "ControlNC"
            return statusline.hl(setup.config.winbar.controls.icons.step_back, hl)
        end,
        action = function()
            dap.step_back()
        end,
    },
    run_last = {
        render = function()
            return statusline.hl(setup.config.winbar.controls.icons.run_last, "ControlRunLast")
        end,
        action = function()
            dap.run_last()
        end,
    },
    terminate = {
        render = function()
            local hl = dap.session() and "ControlTerminate" or "ControlNC"
            return statusline.hl(setup.config.winbar.controls.icons.terminate, hl)
        end,
        action = function()
            dap.terminate()
        end,
    },
    disconnect = {
        render = function()
            local hl = dap.session() and "ControlDisconnect" or "ControlNC"
            return statusline.hl(setup.config.winbar.controls.icons.disconnect, hl)
        end,
        action = function()
            dap.disconnect()
        end,
    },
}

---@param idx integer
---@param clicks integer
---@param button '"l"' | '"r"' | '"m"'
---@param modifiers string
M.on_click = function(idx, clicks, button, modifiers)
    local config = setup.config.winbar.controls
    local key = config.buttons[idx]
    local control = config.custom_buttons[key] or buttons[key]
    control.action(clicks, button, modifiers)
end

---@return string
M.render = function()
    local config = setup.config.winbar.controls
    local bar = ""
    for idx, key in ipairs(config.buttons) do
        local control = config.custom_buttons[key] or buttons[key]
        local icon = " " .. control.render() .. " "
        bar = bar .. statusline.clickable(icon, module, "on_click", idx)
    end
    return bar
end

return M
