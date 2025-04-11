local M = {}

---@param config WinbarConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("winbar", {
        show = { config.show, "boolean" },
        sections = { config.sections, "table" },
        default_section = { config.default_section, "string" },
        headers = { config.headers, "table" },
    }, config)

    validate("winbar.headers", {
        breakpoints = { config.headers.breakpoints, "string" },
        scopes = { config.headers.scopes, "string" },
        exceptions = { config.headers.exceptions, "string" },
        watches = { config.headers.watches, "string" },
        threads = { config.headers.threads, "string" },
        repl = { config.headers.repl, "string" },
        console = { config.headers.console, "string" },
    }, config.headers)

    local sections = config.sections
    local default = config.default_section

    -- Also check the "semantics"
    if #sections == 0 then
        error("There must be at least one section")
    end
    if not vim.tbl_contains(sections, default) then
        local pretty_sections = vim.inspect(sections)
        error("Default section (" .. default .. ") not listed as one of the sections " .. pretty_sections)
    end
end

return M
