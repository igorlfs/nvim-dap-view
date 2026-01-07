local M = {}

local validate = require("dap-view.setup.validate.util").validate

---@param config dapview.WindowsConfig
function M.validate(config)
    validate("windows", {
        size = { config.size, { "number", "function" } },
        position = { config.position, { "string", "function" } },
        terminal = { config.terminal, "table" },
        anchor = { config.anchor, { "function", "nil" } },
    }, config)

    validate("windows.terminal", {
        position = { config.terminal.position, { "string", "function" } },
        hide = { config.terminal.hide, "table" },
        size = { config.terminal.size, { "number", "function" } },
        start_hidden = { config.terminal.start_hidden, "boolean" },
    }, config.terminal)
end

return M
