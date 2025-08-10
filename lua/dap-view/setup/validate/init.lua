local M = {}

---@param config dapview.ConfigStrict
function M.validate(config)
    require("dap-view.setup.validate.util").validate("config", {
        windows = { config.windows, "table" },
        winbar = { config.winbar, "table" },
        help = { config.help, "table" },
        switchbuf = { config.switchbuf, "string" },
        icons = { config.icons, "table" },
        auto_toggle = { config.auto_toggle, "boolean" },
    }, config)

    require("dap-view.setup.validate.winbar").validate(config.winbar)
    require("dap-view.setup.validate.windows").validate(config.windows)
    require("dap-view.setup.validate.help").validate(config.help)
    require("dap-view.setup.validate.icons").validate(config.icons)
end

return M
