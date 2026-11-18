local trigger = require("dap-view.util.trigger")

---@type {[string]: {action: fun():(nil), desc: string}}
return {
    toggle_filter = {
        action = function()
            trigger.at_cursor(require("dap-view.exceptions.actions").toggle_exception_filter)
        end,
        desc = "toggle filter",
    },
    set_condition = {
        action = function()
            trigger.at_cursor(require("dap-view.exceptions.actions").set_conditon)
        end,
        desc = "set condition",
    },
    clear_condition = {
        action = function()
            trigger.at_cursor(require("dap-view.exceptions.actions").clear_conditon)
        end,
        desc = "clear condition",
    },
}
