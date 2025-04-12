local M = {}

---@param config WinbarConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("winbar", {
        show = { config.show, "boolean" },
        sections = { config.sections, "table" },
        default_section = { config.default_section, "string" },
        headers = { config.headers, "table" },
        controls = { config.controls, "table" },
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

    validate("winbar.controls", {
        enabled = { config.controls.enabled, "boolean" },
        position = { config.controls.position, "string" },
        buttons = { config.controls.buttons, "table" },
        icons = { config.controls.icons, "table" },
    }, config.controls)

    validate("winbar.controls.icons", {
        pause = { config.controls.icons.pause, "string" },
        play = { config.controls.icons.play, "string" },
        step_into = { config.controls.icons.step_into, "string" },
        step_over = { config.controls.icons.step_over, "string" },
        step_out = { config.controls.icons.step_out, "string" },
        step_back = { config.controls.icons.step_back, "string" },
        disconnect = { config.controls.icons.disconnect, "string" },
        terminate = { config.controls.icons.terminate, "string" },
        run_last = { config.controls.icons.run_last, "string" },
    }, config.controls.icons)

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
