local M = {}

---@param config dapview.HelpConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("help", {
        border = {
            config.border,
            function(v)
                return v == nil or type(v) == "string" or type(v) == "table"
            end,
            "string|string[]|nil",
        },
    }, config)
end

return M
