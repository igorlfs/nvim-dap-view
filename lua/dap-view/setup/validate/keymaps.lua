local M = {}

local validate = require("dap-view.setup.validate.util").validate

---@param config dapview.KeymapsConfig
function M.validate(config)
    validate("keymaps", {
        scopes = { config.scopes, "table" },
        watches = { config.watches, "table" },
        hover = { config.hover, "table" },
        base = { config.base, "table" },
        console = { config.console, "table" },
        help = { config.help, "table" },
        threads = { config.threads, "table" },
        exceptions = { config.exceptions, "table" },
        sessions = { config.sessions, "table" },
        breakpoints = { config.breakpoints, "table" },
    }, config)

    local scopes = config.scopes
    validate("keymaps.scopes", {
        set_value = { scopes.set_value, { "table", "string" } },
        jump_to_parent = { scopes.jump_to_parent, { "table", "string" } },
        toggle = { scopes.toggle, { "table", "string" } },
    }, scopes)

    local watches = config.watches
    validate("keymaps.watches", {
        jump_to_parent = { watches.jump_to_parent, { "table", "string" } },
        toggle = { watches.toggle, { "table", "string" } },
        set_value = { watches.set_value, { "table", "string" } },
        copy_value = { watches.copy_value, { "table", "string" } },
        delete_expression = { watches.delete_expression, { "table", "string" } },
        append_expression = { watches.append_expression, { "table", "string" } },
        insert_expression = { watches.insert_expression, { "table", "string" } },
        edit_expression = { watches.edit_expression, { "table", "string" } },
    }, watches)

    local hover = config.hover
    validate("keymaps.hover", {
        quit = { hover.quit, { "table", "string" } },
        set_value = { hover.set_value, { "table", "string" } },
        jump_to_parent = { hover.jump_to_parent, { "table", "string" } },
        toggle = { hover.toggle, { "table", "string" } },
    }, hover)

    local help = config.help
    validate("keymaps.help", {
        quit = { help.quit, { "table", "string" } },
    }, help)

    local console = config.console
    validate("keymaps.console", {
        next_session = { console.next_session, { "table", "string" } },
        prev_session = { console.prev_session, { "table", "string" } },
    }, console)

    local threads = config.threads
    validate("keymaps.threads", {
        toggle_subtle_frames = { threads.toggle_subtle_frames, { "table", "string" } },
        filter = { threads.filter, { "table", "string" } },
        invert_filter = { threads.invert_filter, { "table", "string" } },
        jump_to_frame = { threads.jump_to_frame, { "table", "string" } },
        force_jump = { threads.force_jump, { "table", "string" } },
    }, threads)

    local exceptions = config.exceptions
    validate("keymaps.exceptions", {
        toggle_fitler = { exceptions.toggle_filter, { "table", "string" } },
    }, exceptions)

    local sessions = config.sessions
    validate("keymaps.sessions", {
        switch_session = { sessions.switch_session, { "table", "string" } },
    }, sessions)

    local breakpoints = config.breakpoints
    validate("keymaps.breakpoints", {
        delete_breakpoint = { breakpoints.delete_breakpoint, { "table", "string" } },
        jump_to_breakpoint = { breakpoints.jump_to_breakpoint, { "table", "string" } },
        force_jump = { breakpoints.force_jump, { "table", "string" } },
    }, breakpoints)

    local base = config.base
    validate("keymaps.base", {
        next_view = { base.next_view, { "table", "string" } },
        prev_view = { base.prev_view, { "table", "string" } },
        jump_to_first = { base.jump_to_first, { "table", "string" } },
        jump_to_last = { base.jump_to_last, { "table", "string" } },
        help = { base.help, { "table", "string" } },
    }, base)
end

return M
