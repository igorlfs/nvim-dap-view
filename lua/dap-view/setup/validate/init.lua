local M = {}

---@param config dapview.ConfigStrict
function M.validate(config)
    require("dap-view.setup.validate.util").validate("config", {
        windows = { config.windows, "table" },
        winbar = { config.winbar, "table" },
        switchbuf = { config.switchbuf, "string" },
    }, config)

    require("dap-view.setup.validate.winbar").validate(config.winbar)
    require("dap-view.setup.validate.windows").validate(config.windows)
end

return M
