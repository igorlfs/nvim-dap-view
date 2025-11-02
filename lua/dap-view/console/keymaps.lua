local keymap = require("dap-view.views.keymaps.util").keymap
local setup = require("dap-view.setup")

local M = {}

---@param buf integer
M.set_keymaps = function(buf)
    keymap("]s", function()
        require("dap-view").navigate({ count = vim.v.count1, wrap = true, type = "sessions" })
    end, buf)

    keymap("[s", function()
        require("dap-view").navigate({ count = -vim.v.count1, wrap = true, type = "sessions" })
    end, buf)

    require("dap-view.options.winbar").set_action_keymaps(buf)

    local console_config = setup.config.console

    if not console_config.capture_ctrl_c then
        return
    end

    vim.keymap.set("t", "<C-c>", function()
        local term_escape = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
        vim.api.nvim_feedkeys(term_escape, "n", false)

        require("dap-view.options.winbar").refresh_winbar("console")
    end, { desc = "Exit terminal mode" })
end

return M
