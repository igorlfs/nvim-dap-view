local setup = require("dap-view.setup")

local M = {}

local api = vim.api
local log = vim.log.levels

---@param pattern string
---@param column? number
M.jump_to_location = function(pattern, column)
    local line = vim.fn.getline(".")

    if not line or line == "" then
        vim.notify("No valid line under the cursor", log.ERROR)
        return
    end

    local file, line_num = line:match(pattern)
    if not file or not line_num then
        vim.notify("Invalid format: " .. line, log.ERROR)
        return
    end

    line_num = tonumber(line_num)
    if not line_num then
        vim.notify("Invalid line number: " .. line_num, log.ERROR)
        return
    end

    local abs_path = vim.fn.fnamemodify(file, ":p")
    if not vim.uv.fs_stat(abs_path) then
        vim.notify("File not found: " .. abs_path, log.ERROR)
        return
    end

    local windows = api.nvim_tabpage_list_wins(0)

    -- TODO this simply finds the first suitable window
    -- A better approach could try to match the paths to avoid jumping around
    -- Or perhaps there's a way to respect the 'switchbuf' option
    local prev_or_new_window = vim.iter(windows)
        :filter(function(w)
            local bufnr = api.nvim_win_get_buf(w)
            return vim.bo[bufnr].buftype == ""
        end)
        :find(function(w)
            return w
        end)

    if not prev_or_new_window then
        prev_or_new_window = api.nvim_open_win(0, true, {
            split = "above",
            win = -1,
            height = vim.o.lines - setup.config.windows.height,
        })
    end

    api.nvim_win_call(prev_or_new_window, function()
        local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(abs_path))
        api.nvim_set_current_buf(bufnr)
    end)

    api.nvim_win_set_cursor(prev_or_new_window, { line_num, column or 0 })

    api.nvim_set_current_win(prev_or_new_window)
end

return M
