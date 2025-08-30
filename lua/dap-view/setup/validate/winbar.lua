local M = {}

---@param config dapview.WinbarConfig
function M.validate(config)
    local validate = require("dap-view.setup.validate.util").validate

    validate("winbar", {
        show = { config.show, "boolean" },
        sections = { config.sections, "table" },
        default_section = { config.default_section, "string" },
        base_sections = { config.base_sections, "table" },
        controls = { config.controls, "table" },
        custom_sections = { config.custom_sections, "table" },
    }, config)

    local base_sections = config.base_sections
    validate("winbar.sections", {
        breakpoints = { base_sections.breakpoints, "table" },
        scopes = { base_sections.scopes, "table" },
        exceptions = { base_sections.exceptions, "table" },
        watches = { base_sections.watches, "table" },
        threads = { base_sections.threads, "table" },
        repl = { base_sections.repl, "table" },
        sessions = { base_sections.sessions, "table" },
        console = { base_sections.console, "table" },
    }, base_sections)

    validate("winbar.sections.breakpoints", {
        keymap = { base_sections.breakpoints.keymap, "string" },
        label = { base_sections.breakpoints.label, "string" },
        short_label = { base_sections.breakpoints.short_label, "string" },
        action = { base_sections.breakpoints.action, "function" },
    }, base_sections.breakpoints)

    validate("winbar.sections.scopes", {
        keymap = { base_sections.scopes.keymap, "string" },
        label = { base_sections.scopes.label, "string" },
        short_label = { base_sections.scopes.short_label, "string" },
        action = { base_sections.scopes.action, "function" },
    }, base_sections.scopes)

    validate("winbar.sections.exceptions", {
        keymap = { base_sections.exceptions.keymap, "string" },
        label = { base_sections.exceptions.label, "string" },
        short_label = { base_sections.exceptions.short_label, "string" },
        action = { base_sections.exceptions.action, "function" },
    }, base_sections.exceptions)

    validate("winbar.sections.watches", {
        keymap = { base_sections.watches.keymap, "string" },
        label = { base_sections.watches.label, "string" },
        short_label = { base_sections.watches.short_label, "string" },
        action = { base_sections.watches.action, "function" },
    }, base_sections.watches)

    validate("winbar.sections.threads", {
        keymap = { base_sections.threads.keymap, "string" },
        label = { base_sections.threads.label, "string" },
        short_label = { base_sections.threads.short_label, "string" },
        action = { base_sections.threads.action, "function" },
    }, base_sections.threads)

    validate("winbar.sections.repl", {
        keymap = { base_sections.repl.keymap, "string" },
        label = { base_sections.repl.label, "string" },
        short_label = { base_sections.repl.short_label, "string" },
        action = { base_sections.repl.action, "function" },
    }, base_sections.repl)

    validate("winbar.sections.sessions", {
        keymap = { base_sections.sessions.keymap, "string" },
        label = { base_sections.sessions.label, "string" },
        short_label = { base_sections.sessions.short_label, "string" },
        action = { base_sections.sessions.action, "function" },
    }, base_sections.sessions)

    validate("winbar.sections.console", {
        keymap = { base_sections.console.keymap, "string" },
        label = { base_sections.console.label, "string" },
        short_label = { base_sections.console.short_label, "string" },
        action = { base_sections.console.action, "function" },
    }, base_sections.console)

    local controls = config.controls
    validate("winbar.controls", {
        enabled = { controls.enabled, "boolean" },
        position = { controls.position, "string" },
        buttons = { controls.buttons, "table" },
        custom_buttons = { controls.custom_buttons, "table" },
    }, controls)

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
