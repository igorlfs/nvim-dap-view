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

---@param callback fun(): nil
M.switch_to_view = function(callback)
    if not state.bufnr or not state.winnr or not api.nvim_win_is_valid(state.winnr) then
        return
    end

    if vim.tbl_contains({ "repl", "console" }, state.current_section) then
        api.nvim_win_call(state.winnr, function()
            api.nvim_set_current_buf(state.bufnr)
        end)
    end

    callback()
end

return M
