local setup = require("dap-view.setup")
local window = require("dap-view.views.windows")
local util = require("dap-view.util")

local M = {}

local api = vim.api
local log = vim.log.levels

---@param file_path string
M.get_bufnr_from_path = function(file_path)
    local abs_path = vim.fn.fnamemodify(file_path, ":p")

    if not vim.uv.fs_stat(abs_path) then
        vim.notify("File not found: " .. abs_path, log.ERROR)
        return
    end

    local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(abs_path))

    return bufnr
end

---@param file_path string
---@param line integer
---@param column? integer
---@param switchbuffun? dapview.SwitchBufFun
M.jump_to_location = function(file_path, line, column, switchbuffun)
    local bufnr = M.get_bufnr_from_path(file_path)

    if bufnr == nil then
        return
    end

    local config = setup.config

    ---@type integer?
    local win

    if switchbuffun then
        win = window.get_win_respecting_switchbuf(switchbuffun, bufnr)
    else
        win = window.get_win_respecting_switchbuf(config.switchbuf, bufnr)
    end

    if win == nil then
        local windows = config.windows

        local position = windows.position
        local pos = (type(position) == "function" and position()) or (type(position) == "string" and position)

        win = api.nvim_open_win(0, true, {
            split = util.inverted_directions[pos],
            win = -1,
        })
    end

    api.nvim_win_call(win, function()
        api.nvim_set_current_buf(bufnr)
    end)

    api.nvim_win_set_cursor(win, { line, column or 0 })

    api.nvim_set_current_win(win)
end

return M
