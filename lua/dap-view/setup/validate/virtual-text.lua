local M = {}

---@param config dapview.VirtualTextConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("virtual_text", {
        enabled = { config.enabled, "boolean" },
        position = { config.position, "string" },
        format = { config.format, "function" },
        prefix = { config.prefix, "function" },
        suffix = { config.suffix, "function" },
    }, config)
end

return M
