local trigger = require("dap-view.util.trigger")

---@type {[string]: {action: fun():(nil), desc: string}}
return {
    toggle = {
        action = function()
            trigger.at_cursor(function(line)
                if require("dap-view.scopes.actions").expand_or_collapse(line) then
                    coroutine.wrap(function()
                        require("dap-view.views").switch_to_view("scopes", true)
                    end)()
                end
            end)
        end,
        desc = "toggle",
    },
    jump_to_parent = {
        action = function()
            trigger.at_cursor(require("dap-view.scopes.actions").jump_to_parent)
        end,
        desc = "jump to parent",
    },
    set_value = {
        action = function()
            trigger.at_cursor(function(line)
                if require("dap-view.scopes.actions").set_value(line) then
                    coroutine.wrap(function()
                        require("dap-view.views").switch_to_view("scopes")
                    end)()
                end
            end)
        end,
        desc = "set value",
    },
}
