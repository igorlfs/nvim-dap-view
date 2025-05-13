local M = {}

-- From https://github.com/ibhagwan/fzf-lua/blob/9a1f4b6f9e37d6fad6730301af58c29b00d363f8/lua/fzf-lua/actions.lua#L1079-L1101
M.remove_breakpoint = function()
    local dap_breakpoints = require("dap.breakpoints")

    local bufnr, line_num = require("dap-view.views.util").get_bufnr("^(.-)|(%d+)|")

    dap_breakpoints.remove(bufnr, line_num)

    local session = require("dap").session()
    if session and bufnr then
        local breapoints = dap_breakpoints.get()
        -- If all BPs were removed from a buffer we must clear the buffer by sending an empty table in the bufnr index
        breapoints[bufnr] = breapoints[bufnr] or {}
        session:set_breakpoints(breapoints)
    end
end

return M
