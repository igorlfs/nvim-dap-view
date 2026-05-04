local switchbuf = require("dap-view.views.windows.switchbuf")

local M = {}

local api = vim.api

---@param switchbufopt string|dapview.SwitchBufFun
---@param bufnr integer
M.get_win_respecting_switchbuf = function(switchbufopt, bufnr)
    local winnr = api.nvim_get_current_win()

    local switchbuf_winfn = switchbuf.switchbuf_winfn

    if type(switchbufopt) == "function" then
        return switchbufopt(bufnr, winnr)
    end

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

---@param line integer
---@param cb fun(line: integer, cb: fun():nil):nil
M.force_jump = function(line, cb)
    local options = vim.iter(switchbuf.switchbuf_winfn):fold({}, function(acc, k, v)
        acc[#acc + 1] = { label = k, cb = v }
        return acc
    end)

    local setup = require("dap-view.setup")
    if type(setup.config.switchbuf) == "function" then
        options[#options + 1] = { label = "custom", cb = setup.config.switchbuf }
    end

    vim.ui.select(
        options,
        {
            prompt = "Specify jump behavior: ",
            ---@param item {label: string}
            format_item = function(item)
                return item.label
            end,
        },
        ---@param choice {label: string, cb: dapview.SwitchBufFun}?
        function(choice)
            if choice ~= nil then
                cb(line, choice.cb)
            end
        end
    )
end

return M
