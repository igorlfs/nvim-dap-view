local M = {}

local validate = require("dap-view.setup.validate.util").validate

---@param config dapview.WindowsConfig
function M.validate(config)
    validate("windows", {
        height = { config.height, "number" },
        position = { config.position, "string" },
        terminal = { config.terminal, "table" },
        anchor = { config.anchor, { "function", "nil" } },
    }, config)

    validate("windows.terminal", {
        position = { config.terminal.position, "string" },
        hide = { config.terminal.hide, "table" },
        width = { config.terminal.width, "number" },
        start_hidden = { config.terminal.start_hidden, "boolean" },
    }, config.terminal)
end

return M
