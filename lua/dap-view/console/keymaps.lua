---@type {[string]: {action: fun():(nil), desc: string}}
return {
    next_session = {
        action = function()
            require("dap-view").navigate({ count = vim.v.count1, wrap = true, type = "sessions" })
        end,
        desc = "go to next session",
    },
    prev_session = {
        action = function()
            require("dap-view").navigate({ count = -vim.v.count1, wrap = true, type = "sessions" })
        end,
        desc = "go to prev session",
    },
}
