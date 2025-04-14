local M = {}

local validate = require("dap-view.setup.validate.util").validate

---@param config WindowsConfig
function M.validate(config)
    validate("windows", {
        height = { config.height, "number" },
        terminal = { config.terminal, "table" },
    }, config)

    validate("windows.terminal", {
        position = { config.terminal.position, "string" },
        hide = { config.terminal.hide, "table" },
        width = { config.terminal.width, "number" },
        start_hidden = { config.terminal.start_hidden, "boolean" },
    }, config.terminal)
end

return M
