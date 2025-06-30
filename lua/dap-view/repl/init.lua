local state = require("dap-view.state")
local setup = require("dap-view.setup")
local winbar = require("dap-view.options.winbar")
local util = require("dap-view.util")

local M = {}

M.show = function()
    if vim.tbl_contains(setup.config.winbar.sections, "repl") then
        if not util.is_win_valid(state.winnr) then
            return
        end

        -- Jump to dap-view's window to make the experience seamless
        local cmd = "lua vim.api.nvim_set_current_win(" .. state.winnr .. ")"
        local repl_buf, _ = require("dap").repl.open(nil, cmd)

        -- The REPL is a new buffer, so we need to set the winbar keymaps again
        winbar.set_winbar_action_keymaps(repl_buf)

        winbar.update_section("repl")
    end
end

return M
