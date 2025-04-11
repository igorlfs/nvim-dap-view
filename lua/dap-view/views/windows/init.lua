local switchbuf = require("dap-view.views.windows.switchbuf")

local M = {}

local api = vim.api

---@param switchbufopt string
---@param bufnr integer
M.get_win_respecting_switchbuf = function(switchbufopt, bufnr)
    local winnr = api.nvim_get_current_win()

    local switchbuf_winfn = switchbuf.switchbuf_winfn

    if switchbufopt:find("usetab") then
        switchbuf_winfn.useopen = switchbuf_winfn.usetab
    end

    local opts = vim.split(switchbufopt, ",", { plain = true })
    for _, opt in pairs(opts) do
        local winfn = switchbuf.switchbuf_winfn[opt]
        if winfn then
            local win = winfn(bufnr, winnr)
            if win then
                return win
            end
        end
    end
end

return M
