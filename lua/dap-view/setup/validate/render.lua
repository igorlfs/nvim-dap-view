local M = {}

---@param config dapview.RenderConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("render", {
        sort_variables = { config.sort_variables, { "function", "nil" } },
        threads = { config.threads, { "table" } },
        breakpoints = { config.breakpoints, { "table" } },
    }, config)

    local threads = config.threads
    validate("render.threads", {
        format = { threads.format, { "function" } },
    }, threads)

    local breakpoints = config.breakpoints
    validate("render.breakpoints", {
        format = { breakpoints.format, { "function" } },
    }, breakpoints)
end

return M
