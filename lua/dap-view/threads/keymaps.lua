local state = require("dap-view.state")
local trigger = require("dap-view.util.trigger")

-- smh https://github.com/LuaLS/lua-language-server/issues/2589

---@type {[string]: {action: fun():(nil), desc: string}}
return {
    toggle_subtle_frames = {
        action = function()
            state.subtle_frames = not state.subtle_frames

            require("dap-view.views").switch_to_view("threads")
        end,
        desc = "toggle subtle frames",
    },
    filter = {
        action = function()
            vim.ui.input({ prompt = "Filter: ", default = state.threads_filter }, function(input)
                if input then
                    state.threads_filter = input

                    require("dap-view.views").switch_to_view("threads")
                end
            end)
        end,
        desc = "filter frames",
    },
    invert_filter = {
        action = function()
            state.threads_filter_invert = not state.threads_filter_invert

            require("dap-view.views").switch_to_view("threads")
        end,
        desc = "invert filter",
    },
    jump_to_frame = {
        action = function()
            trigger.at_cursor(require("dap-view.threads.actions").jump_and_set_frame)
        end,
        desc = "jump to frame",
    },
    force_jump = {
        action = function()
            trigger.at_cursor(function(line)
                require("dap-view.views.windows").force_jump(
                    line,
                    require("dap-view.threads.actions").jump_and_set_frame
                )
            end)
        end,
        desc = "force jump",
    },
}
