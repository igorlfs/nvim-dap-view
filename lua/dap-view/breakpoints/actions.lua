local setup = require("dap-view.setup")

local M = {}

local api = vim.api

M._jump_to_breakpoint = function()
    local line = vim.fn.getline(".")

    if not line or line == "" then
        vim.notify("No valid line under the cursor", vim.log.levels.ERROR)
        return
    end

    local file, line_num = line:match("^(.-)|(%d+)|")
    if not file or not line_num then
        vim.notify("Invalid format: " .. line, vim.log.levels.ERROR)
        return
    end

    line_num = tonumber(line_num)
    if not line_num then
        vim.notify("Invalid line number: " .. line_num, vim.log.levels.ERROR)
        return
    end

    local abs_path = vim.fn.fnamemodify(file, ":p")
    if not vim.uv.fs_stat(abs_path) then
        vim.notify("File not found: " .. abs_path, vim.log.levels.ERROR)
        return
    end

    local windows = api.nvim_tabpage_list_wins(0)

    -- TODO this simply finds the first suitable window
    -- A better approach could try to match the paths to avoid jumping around
    -- Or perhaps there's a way to respect the 'switchbuf' option
    local prev_or_new_window = vim.iter(windows)
        :filter(function(w)
            local buf = api.nvim_win_get_buf(w)
            return api.nvim_get_option_value("buftype", { buf = buf }) == ""
        end)
        :find(function(w)
            return w
        end)

    if not prev_or_new_window then
        local config = setup.config
        prev_or_new_window = api.nvim_open_win(0, true, {
            split = "above",
            win = 0,
            height = vim.o.lines - config.windows.height,
        })
    end

    api.nvim_win_call(prev_or_new_window, function()
        local bufnr = vim.fn.bufnr(abs_path)
        if bufnr == -1 then
            vim.cmd("buffer " .. abs_path)
        else
            api.nvim_set_current_buf(bufnr)
        end
    end)

    api.nvim_win_set_cursor(prev_or_new_window, { line_num, 0 })

    api.nvim_set_current_win(prev_or_new_window)
end

return M
