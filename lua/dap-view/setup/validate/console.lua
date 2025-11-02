local M = {}

local validate = require("dap-view.setup.validate.util").validate

---@param config dapview.ConsoleConfig
function M.validate(config)
    validate("console", {
        capture_ctrl_c = { config.capture_ctrl_c, "boolean" },
    }, config)
end

return M
