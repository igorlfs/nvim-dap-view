local help = require("dap-view.views.keymaps.help")
local keymap = require("dap-view.views.keymaps.util").keymap

local M = {}

---@param buf integer?
M.set_keymaps = function(buf)
    keymap("]v", function()
        require("dap-view").navigate({ count = vim.v.count1, wrap = true })
    end, buf)

    keymap("[v", function()
        require("dap-view").navigate({ count = -vim.v.count1, wrap = true })
    end, buf)

    keymap("]V", function()
        require("dap-view").navigate({ count = vim._maxint, wrap = false })
    end, buf)

    keymap("[V", function()
        require("dap-view").navigate({ count = -vim._maxint, wrap = false })
    end, buf)

    if not buf then
        require("dap-view.views.keymaps.views").views_keysmps()
    end

    keymap("g?", function()
        help.show_help()
    end, buf)
end

return M
