local setup = require("dap-view.setup")
local help = require("dap-view.views.keymaps.help")

local keymap = require("dap-view.views.keymaps.util").keymap

local M = {}

---@param buf integer?
M.set_keymaps = function(buf)
    local keys = setup.config.keymaps.base

    keymap(keys.next_view, function()
        require("dap-view").navigate({ count = vim.v.count1, wrap = true })
    end, { buf = buf, desc = "go to next view" })

    keymap(keys.prev_view, function()
        require("dap-view").navigate({ count = -vim.v.count1, wrap = true })
    end, { buf = buf, desc = "go to prev view" })

    keymap(keys.jump_to_last, function()
        require("dap-view").navigate({ count = vim._maxint, wrap = false })
    end, { buf = buf, desc = "jump to last view" })

    keymap(keys.jump_to_first, function()
        require("dap-view").navigate({ count = -vim._maxint, wrap = false })
    end, { buf = buf, desc = "jump to first view" })

    keymap(keys.help, function()
        help.show_help()
    end, { buf = buf, desc = "show help" })
end

return M
