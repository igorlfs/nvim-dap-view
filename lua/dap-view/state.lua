local dap = require("dap")

local setup = require("dap-view.setup")

local api = vim.api

---@class ExceptionsOption
---@field exception_filter dap.ExceptionBreakpointsFilter
---@field enabled boolean

---@class State
---@field bufnr? integer
---@field winnr? integer
---@field term_bufnr? integer
---@field term_winnr? integer
---@field last_active_adapter? string
---@field current_section? SectionType
---@field exceptions_options? ExceptionsOption[]
---@field watched_expressions string[]
---@field expression_results string[]
---@field updated_evaluations boolean[]
local M = {
    watched_expressions = {},
    expression_results = {},
    updated_evaluations = {},
}

---@return boolean?
M.should_create_terminal = function()
    local is_term_hidden = vim.tbl_contains(setup.config.windows.terminal.hide, M.last_active_adapter)
    local not_hidden = dap.session() and M.term_bufnr and not is_term_hidden
    local is_valid = M.term_winnr == nil or M.term_winnr and not api.nvim_win_is_valid(M.term_winnr)
    return not_hidden and is_valid
end

local is_term_winnr_valid = function()
    return M.term_winnr ~= nil and api.nvim_win_is_valid(M.term_winnr)
end

---@return table
M.get_term_window_config = function()
    local terminal = setup.config.windows.terminal
    local config = {
        split = is_term_winnr_valid() and (terminal.position == "left" and "right" or "left") or "below",
        win = is_term_winnr_valid() and M.term_winnr or -1,
        height = setup.config.windows.height,
    }
    return config
end

return M
