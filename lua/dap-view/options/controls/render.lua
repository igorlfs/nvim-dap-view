local dap = require("dap")

local statusline = require("dap-view.util.statusline")

local M = {}

---Avoid require loop by lazy loading
local get_icons = function(base_button) ---@param base_button dapview.DefaultButton
    return require("dap-view.setup").config.winbar.controls.base_buttons[base_button].icons
end

---@param hl_active string
---@param session dap.Session|nil
local stopped_or_default_hl = function(hl_active, session)
    return session and session.stopped_thread_id and hl_active or "ControlNC"
end

M.play = function()
    local icons = get_icons("play")
    local session = dap.session()
    local pausable = session and not session.stopped_thread_id
    return pausable and statusline.hl(icons[1], "ControlPause") or statusline.hl(icons[2], "ControlPlay")
end

M.step_into = function()
    local session = dap.session()
    local icons = get_icons("step_into")
    return statusline.hl(icons[1], stopped_or_default_hl("ControlStepInto", session))
end

M.step_over = function()
    local session = dap.session()
    local icons = get_icons("step_over")
    return statusline.hl(icons[1], stopped_or_default_hl("ControlStepOver", session))
end

M.step_out = function()
    local session = dap.session()
    local icons = get_icons("step_out")
    return statusline.hl(icons[1], stopped_or_default_hl("ControlStepOut", session))
end

M.step_back = function()
    local session = dap.session()
    local icons = get_icons("step_back")
    return statusline.hl(icons[1], stopped_or_default_hl("ControlStepBack", session))
end

M.run_last = function()
    local icons = get_icons("run_last")
    return statusline.hl(icons[1], "ControlRunLast")
end

M.terminate = function()
    local icons = get_icons("terminate")
    return statusline.hl(icons[1], dap.session() and "ControlTerminate" or "ControlNC")
end

M.disconnect = function()
    local icons = get_icons("disconnect")
    return statusline.hl(icons[1], dap.session() and "ControlDisconnect" or "ControlNC")
end

return M
