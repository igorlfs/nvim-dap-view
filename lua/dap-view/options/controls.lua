local highlight = require("dap-view.highlight")
local setup = require("dap-view.setup")
local dap = require("dap")
local module = ...

local M = {}

local buttons = {
    play = {
        render = function()
            local session = dap.session()
            if not session or session.stopped_thread_id then
                return highlight.hl(setup.config.winbar.controls.icons.play, "ControlPlay")
            else
                return highlight.hl(setup.config.winbar.controls.icons.pause, "ControlPause")
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
            return highlight.hl(setup.config.winbar.controls.icons.step_into, hl)
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
            return highlight.hl(setup.config.winbar.controls.icons.step_over, hl)
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
            return highlight.hl(setup.config.winbar.controls.icons.step_out, hl)
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
            return highlight.hl(setup.config.winbar.controls.icons.step_back, hl)
        end,
        action = function()
            dap.step_back()
        end,
    },
    run_last = {
        render = function()
            return highlight.hl(setup.config.winbar.controls.icons.run_last, "ControlRunLast")
        end,
        action = function()
            dap.run_last()
        end,
    },
    terminate = {
        render = function()
            local hl = dap.session() and "ControlTerminate" or "ControlNC"
            return highlight.hl(setup.config.winbar.controls.icons.terminate, hl)
        end,
        action = function()
            dap.terminate()
        end,
    },
    disconnect = {
        render = function()
            local hl = dap.session() and "ControlDisconnect" or "ControlNC"
            return highlight.hl(setup.config.winbar.controls.icons.disconnect, hl)
        end,
        action = function()
            dap.disconnect()
        end,
    },
}

---@param idx integer
M.on_click = function(idx)
    local key = setup.config.winbar.controls.buttons[idx]
    local control = buttons[key]
    control.action()
end

M.render = function()
    local config = setup.config.winbar.controls
    local bar = ""
    for idx, key in ipairs(config.buttons) do
        local control = buttons[key]
        local icon = " " .. control.render() .. " "
        bar = bar .. highlight.clickable(icon, module, "on_click", idx)
    end
    return bar
end

M.enabled_left = function()
    local config = setup.config.winbar.controls
    return config.enabled and config.position == "left"
end

M.enabled_right = function()
    local config = setup.config.winbar.controls
    return config.enabled and config.position == "right"
end

return M
