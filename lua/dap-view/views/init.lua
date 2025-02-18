local state = require("dap-view.state")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

---@param cond boolean
---@param message string
M.cleanup_view = function(cond, message)
    if cond then
        vim.wo[state.winnr].cursorline = false

        api.nvim_buf_set_lines(state.bufnr, 0, -1, false, { message })

        hl.hl_range("MissingData", { 0, 0 }, { 0, #message })
    else
        vim.wo[state.winnr].cursorline = true
    end

    return cond
end

local switch_to_dapview_buf = function()
    if not (state.winnr and api.nvim_win_is_valid(state.winnr)) then
        return
    end
    -- The REPL is actually another buffer
    if state.current_section == "repl" then
        api.nvim_win_call(state.winnr, function()
            api.nvim_set_current_buf(state.bufnr)
        end)
    end
end

---@param callback fun(): nil
M.switch = function(callback)
    switch_to_dapview_buf()
    callback()
end

return M
