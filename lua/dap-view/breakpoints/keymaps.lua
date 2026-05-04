local trigger = require("dap-view.util.trigger")

---@type {[string]: {action: fun():(nil), desc: string}}
return {
    delete_breakpoint = {
        action = function()
            trigger.at_cursor(require("dap-view.breakpoints.actions").remove)

            -- If a session is active, `setBreakpoints` will trigger anyway
            -- It's best avoid a redraw here
            if require("dap").session() == nil then
                require("dap-view.views").switch_to_view("breakpoints")
            end
        end,
        desc = "delete breakpoint",
    },
    jump_to_breakpoint = {
        action = function()
            trigger.at_cursor(require("dap-view.breakpoints.actions").jump)
        end,
        desc = "jump to breakpoint",
    },
    force_jump = {
        action = function()
            trigger.at_cursor(function(line)
                require("dap-view.views.windows").force_jump(line, require("dap-view.breakpoints.actions").jump)
            end)
        end,
        desc = "force jump",
    },
}
