local M = {}

---@param config dapview.VirtualTextConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("virtual_text", {
        enabled = { config.enabled, "boolean" },
        format = { config.format, "function" },
        position = { config.position, "string" },
    }, config)
end

return M
