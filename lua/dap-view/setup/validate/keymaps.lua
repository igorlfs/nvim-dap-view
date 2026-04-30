local M = {}

local validate = require("dap-view.setup.validate.util").validate

---@param config dapview.KeymapsConfig
function M.validate(config)
    validate("keymaps", {
        hover = { config.hover, "table" },
    }, config)

    local hover = config.hover
    validate("keymaps.hover", {
        quit = { hover.quit, { "table", "string" } },
        set_value = { hover.set_value, { "table", "string" } },
        jump_to_parent = { hover.jump_to_parent, { "table", "string" } },
        toggle = { hover.toggle, { "table", "string" } },
    }, config)

    local help = config.help
    validate("keymaps.help", {
        quit = { help.quit, { "table", "string" } },
    }, config)

    local console = config.console
    validate("keymaps.console", {
        next_session = { console.next_session, { "table", "string" } },
        prev_session = { console.prev_session, { "table", "string" } },
    }, config)

    local base = config.base
    validate("keymaps.base", {
        next_view = { base.next_view, { "table", "string" } },
        prev_view = { base.prev_view, { "table", "string" } },
        jump_to_first = { base.jump_to_first, { "table", "string" } },
        jump_to_last = { base.jump_to_last, { "table", "string" } },
        help = { base.help, { "table", "string" } },
    }, config)
end

return M
