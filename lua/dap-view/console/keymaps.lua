local keymap = require("dap-view.views.keymaps.util").keymap

local M = {}

---@param buf integer
M.set_keymaps = function(buf)
    keymap("]s", function()
        require("dap-view").navigate({ count = vim.v.count1, wrap = true, type = "sessions" })
    end, buf)

    keymap("[s", function()
        require("dap-view").navigate({ count = -vim.v.count1, wrap = true, type = "sessions" })
    end, buf)
end

return M
