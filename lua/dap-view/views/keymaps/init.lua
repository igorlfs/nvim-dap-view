local setup = require("dap-view.setup")
local help = require("dap-view.views.keymaps.help")

local keymap = require("dap-view.views.keymaps.util").keymap

local M = {}

---@param buf integer?
M.set_keymaps = function(buf)
    local keys = setup.config.keymaps.base

    keymap(keys.next_view, function()
        require("dap-view").navigate({ count = vim.v.count1, wrap = true })
    end, buf)

    keymap(keys.prev_view, function()
        require("dap-view").navigate({ count = -vim.v.count1, wrap = true })
    end, buf)

    keymap(keys.jump_to_last, function()
        require("dap-view").navigate({ count = vim._maxint, wrap = false })
    end, buf)

    keymap(keys.jump_to_first, function()
        require("dap-view").navigate({ count = -vim._maxint, wrap = false })
    end, buf)

    if not buf then
        require("dap-view.views.keymaps.views").views_keymaps()
    end

    keymap(keys.help, function()
        help.show_help()
    end, buf)
end

return M
