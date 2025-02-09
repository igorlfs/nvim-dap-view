local M = {}

---@param config WindowsConfig
function M.validate(config)
    require("dap-view.setup.validate.util").validate("windows", {
        height = { config.height, "number" },
    }, config)
end

return M
