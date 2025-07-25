local state = require("dap-view.state")
local winbar = require("dap-view.options.winbar")

local M = {}

M.show = function()
    -- Jump to dap-view's window to make the experience seamless
    local cmd = "lua vim.api.nvim_set_current_win(" .. state.winnr .. ")"
    local repl_buf, _ = require("dap").repl.open(nil, cmd)

    -- The REPL is a new buffer, so we need to set the winbar keymaps again
    winbar.set_action_keymaps(repl_buf)

    winbar.refresh_winbar("repl")
end

return M
