local dap = require("dap")

local statusline = require("dap-view.util.statusline")
local setup = require("dap-view.setup")

local M = {}

---@type dapview.ButtonConfig
M.play = {
    render = function(session)
        local pausable = session and not session.stopped_thread_id
        return statusline.hl(
            pausable and setup.config.icons["pause"] or setup.config.icons["play"],
            pausable and "ControlPause" or "ControlPlay"
        )
    end,
    action = function()
        local session = dap.session()
        local action = session and not session.stopped_thread_id and dap.pause or dap.continue
        action()
    end,
}

---@type dapview.ButtonConfig
M.step_into = {
    render = function(session)
        local stopped = session and session.stopped_thread_id
        return statusline.hl(setup.config.icons["step_into"], stopped and "ControlStepInto" or "ControlNC")
    end,
    action = function()
        dap.step_into()
    end,
}

---@type dapview.ButtonConfig
M.step_over = {
    render = function(session)
        local stopped = session and session.stopped_thread_id
        return statusline.hl(setup.config.icons["step_over"], stopped and "ControlStepOver" or "ControlNC")
    end,
    action = function()
        dap.step_over()
    end,
}

---@type dapview.ButtonConfig
M.step_out = {
    render = function(session)
        local stopped = session and session.stopped_thread_id
        return statusline.hl(setup.config.icons["step_out"], stopped and "ControlStepOut" or "ControlNC")
    end,
    action = function()
        dap.step_out()
    end,
}

---@type dapview.ButtonConfig
M.step_back = {
    render = function(session)
        local stopped = session and session.stopped_thread_id
        return statusline.hl(setup.config.icons["step_back"], stopped and "ControlStepBack" or "ControlNC")
    end,
    action = function()
        dap.step_back()
    end,
}

---@type dapview.ButtonConfig
M.run_last = {
    render = function()
        return statusline.hl(setup.config.icons["run_last"], "ControlRunLast")
    end,
    action = function()
        dap.run_last()
    end,
}

---@type dapview.ButtonConfig
M.terminate = {
    render = function(session)
        return statusline.hl(setup.config.icons["terminate"], session and "ControlTerminate" or "ControlNC")
    end,
    action = function()
        dap.terminate()
    end,
}

---@type dapview.ButtonConfig
M.disconnect = {
    render = function(session)
        return statusline.hl(setup.config.icons["disconnect"], session and "ControlDisconnect" or "ControlNC")
    end,
    action = function()
        dap.disconnect()
    end,
}

return M
