local M = {}

local validate = require("dap-view.setup.validate.util").validate

---@param config dapview.IconsConfig
function M.validate(config)
    validate("icons", {
        collapsed = { config.collapsed, "string" },
        disabled = { config.disabled, "string" },
        disconnect = { config.disconnect, "string" },
        enabled = { config.enabled, "string" },
        expanded = { config.expanded, "string" },
        filter = { config.filter, "string" },
        negate = { config.negate, "string" },
        pause = { config.pause, "string" },
        play = { config.play, "string" },
        run_last = { config.run_last, "string" },
        step_back = { config.step_back, "string" },
        step_into = { config.step_into, "string" },
        step_out = { config.step_out, "string" },
        step_over = { config.step_over, "string" },
        terminate = { config.terminate, "string" },
    }, config)
end

return M
