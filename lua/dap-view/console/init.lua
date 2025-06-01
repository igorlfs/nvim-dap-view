local state = require("dap-view.state")
local winbar = require("dap-view.options.winbar")

local M = {}

local api = vim.api

---@param winnr integer
M.setup_console = function(winnr)
    api.nvim_win_call(winnr, function()
        local term_bufnr = state.term_bufnrs[state.current_session_id]

        api.nvim_set_current_buf(term_bufnr)

        require("dap-view.term.options").set_options(winnr, term_bufnr)

        winbar.set_winbar_action_keymaps(term_bufnr)

        winbar.update_section("console")
    end)
end

return M
