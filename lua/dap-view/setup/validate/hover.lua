local M = {}

---@param config dapview.HoverConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("hover", {
        border = { config.border, { "string", "table", "nil" } },
    }, config)
end

return M
