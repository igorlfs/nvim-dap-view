local M = {}

---@param config dapview.RenderConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("render", {
        sort_variables = { config.sort_variables, { "function", "nil" } },
        threads = { config.threads, { "table" } },
    }, config)

    local threads = config.threads
    validate("render.threads", {
        format = { threads.format, { "function" } },
    }, threads)
end

return M
