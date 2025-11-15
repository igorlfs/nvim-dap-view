local M = {}

---@param config dapview.RenderConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("render", {
        sort_variables = { config.sort_variables, { "function", "nil" } },
    }, config)
end

return M
