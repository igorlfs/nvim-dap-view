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
        base_buttons = { controls.base_buttons, "table" },
    }, controls)

    local base = controls.base_buttons
    validate("winbar.controls.icons", {
        play = { base.play, "table" },
        step_into = { base.step_into, "table" },
        step_over = { base.step_over, "table" },
        step_out = { base.step_out, "table" },
        step_back = { base.step_back, "table" },
        disconnect = { base.disconnect, "table" },
        terminate = { base.terminate, "table" },
        run_last = { base.run_last, "table" },
    }, base)

    local play = base.play
    validate("winbar.controls.base_buttons.play", {
        action = { play.action, "function" },
        render = { play.render, "function" },
    }, play)

    local step_into = base.step_into
    validate("winbar.controls.base_buttons.step_into", {
        action = { step_into.action, "function" },
        render = { step_into.render, "function" },
    }, step_into)

    local step_over = base.step_over
    validate("winbar.controls.base_buttons.step_over", {
        action = { step_over.action, "function" },
        render = { step_over.render, "function" },
    }, step_over)

    local step_out = base.step_out
    validate("winbar.controls.base_buttons.step_out", {
        action = { step_out.action, "function" },
        render = { step_out.render, "function" },
    }, step_out)

    local step_back = base.step_back
    validate("winbar.controls.base_buttons.step_back", {
        action = { step_back.action, "function" },
        render = { step_back.render, "function" },
    }, step_back)

    local disconnect = base.disconnect
    validate("winbar.controls.base_buttons.disconnect", {
        action = { disconnect.action, "function" },
        render = { disconnect.render, "function" },
    }, disconnect)

    local terminate = base.terminate
    validate("winbar.controls.base_buttons.terminate", {
        action = { terminate.action, "function" },
        render = { terminate.render, "function" },
    }, terminate)

    local run_last = base.run_last
    validate("winbar.controls.base_buttons.run_last", {
        action = { run_last.action, "function" },
        render = { run_last.render, "function" },
    }, run_last)

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
    if default == "console" then
        error("Can't use 'console' as the default section")
    end
end

return M
