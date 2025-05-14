local M = {}

---@param config dapview.HelpConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("help", {
        border = { config.border, { "string", "table", "nil" } },
    }, config)
end

return M
