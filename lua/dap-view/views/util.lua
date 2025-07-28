local setup = require("dap-view.setup")
local window = require("dap-view.views.windows")
local util = require("dap-view.util")

local M = {}

local api = vim.api
local log = vim.log.levels

---@param pattern string
---@return [integer, integer]|nil
M.get_bufnr = function(pattern)
    local line = vim.fn.getline(".")

    if not line or line == "" then
        vim.notify("No valid line under the cursor", log.ERROR)
        return
    end

    local file, lnum = line:match(pattern)
    if not file or not lnum then
        vim.notify("Invalid format: " .. line, log.ERROR)
        return
    end

    local line_num = tonumber(lnum)
    if not line_num then
        vim.notify("Invalid line number: " .. line_num, log.ERROR)
        return
    end

    local abs_path = vim.fn.fnamemodify(file, ":p")
    if not vim.uv.fs_stat(abs_path) then
        vim.notify("File not found: " .. abs_path, log.ERROR)
        return
    end

    local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(abs_path))

    return { bufnr, math.floor(line_num) }
end

---@param pattern string
---@param column? integer
M.jump_to_location = function(pattern, column)
    local bufnr, line_num = unpack(M.get_bufnr(pattern) or {})

    if bufnr == nil then
        return
    end

    local config = setup.config

    local switchbufopt = config.switchbuf
    local win = window.get_win_respecting_switchbuf(switchbufopt, bufnr)

    if not win then
        win = api.nvim_open_win(0, true, {
            split = util.inverted_directions[config.windows.position],
            win = -1,
            height = config.windows.height < 1 and math.floor(vim.go.lines * (1 - config.windows.height))
                or math.floor(vim.go.lines - config.windows.height),
        })
    end

    api.nvim_win_call(win, function()
        api.nvim_set_current_buf(bufnr)
    end)

    api.nvim_win_set_cursor(win, { line_num, column or 0 })

    api.nvim_set_current_win(win)
end

return M
