local trigger = require("dap-view.util.trigger")

---@param append boolean
local new_expression = function(append)
    vim.ui.input({ prompt = "Expression: " }, function(input)
        if input then
            coroutine.wrap(function()
                if require("dap-view.watches.actions").add_watch_expr(input, true, append) then
                    require("dap-view.views").switch_to_view("watches")
                end
            end)()
        end
    end)
end

---@type {[string]: {action: fun():(nil), desc: string}}
return {
    jump_to_parent = {
        action = function()
            trigger.at_cursor(require("dap-view.watches.actions").jump_to_parent)
        end,
        desc = "jump to parent",
    },
    toggle = {
        action = function()
            trigger.at_cursor(function(line)
                coroutine.wrap(function()
                    if require("dap-view.watches.actions").expand_or_collapse(line) then
                        require("dap-view.views").switch_to_view("watches")
                    end
                end)()
            end)
        end,
        desc = "toggle",
    },
    append_expression = {
        action = function()
            new_expression(true)
        end,
        desc = "append expression",
    },
    insert_expression = {
        action = function()
            new_expression(false)
        end,
        desc = "insert expression",
    },
    delete_expression = {
        action = function()
            trigger.at_cursor(function(line)
                if require("dap-view.watches.actions").remove_watch_expr(line) then
                    require("dap-view.views").switch_to_view("watches")
                end
            end)
        end,
        desc = "delete expression",
    },
    edit_expression = {
        action = function()
            trigger.at_cursor(require("dap-view.watches.actions").edit_watch_expr)
        end,
        desc = "edit expression",
    },
    copy_value = {
        action = function()
            trigger.at_cursor(require("dap-view.watches.actions").copy_watch_expr)
        end,
        desc = "copy value",
    },
    set_value = {
        action = function()
            trigger.at_cursor(require("dap-view.watches.actions").set_value)
        end,
        desc = "set value",
    },
}
