local trigger = require("dap-view.util.trigger")

---@type {[string]: {action: fun():(nil), desc: string}}
return {
    switch_session = {
        action = function()
            trigger.at_cursor(require("dap-view.sessions.actions").switch_to_session)
        end,
        desc = "switch session",
    },
}
