local setup = require("dap-view.setup")

local keymap = require("dap-view.views.keymaps.util").keymap

local M = {}

---@param buffer integer
M.set_keymaps = function(buffer)
    local keys = setup.config.keymaps.console

    keymap(keys.next_session, function()
        require("dap-view").navigate({ count = vim.v.count1, wrap = true, type = "sessions" })
    end, { buffer = buffer, desc = "go to next session" })

    keymap(keys.prev_session, function()
        require("dap-view").navigate({ count = -vim.v.count1, wrap = true, type = "sessions" })
    end, { buffer = buffer, desc = "go to prev session" })
end

return M
