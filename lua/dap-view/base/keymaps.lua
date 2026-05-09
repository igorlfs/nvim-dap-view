---@type {[string]: {action: fun():(nil), desc: string}}
return {
    next_view = {
        action = function()
            require("dap-view").navigate({ count = vim.v.count1, wrap = true })
        end,
        desc = "go to next view",
    },
    prev_view = {
        action = function()
            require("dap-view").navigate({ count = -vim.v.count1, wrap = true })
        end,
        desc = "go to prev view",
    },
    jump_to_last = {
        action = function()
            require("dap-view").navigate({ count = vim._maxint, wrap = false })
        end,
        desc = "jump to last view",
    },
    jump_to_first = {
        action = function()
            require("dap-view").navigate({ count = -vim._maxint, wrap = false })
        end,
        desc = "jump to first view",
    },
    help = {
        action = function()
            require("dap-view.views.keymaps.help").show_help()
        end,
        desc = "show help",
    },
}
