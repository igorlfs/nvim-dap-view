-- Let nvim-dap handle terminal buffers internally without interfering in the layout
require("dap").defaults.fallback.terminal_win_cmd = function()
    return vim.api.nvim_create_buf(false, false)
end
