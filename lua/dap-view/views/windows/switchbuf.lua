local M = {}

local api = vim.api

local get_prev_win = function()
    local windows = api.nvim_tabpage_list_wins(0)

    return vim.iter(windows):find(function(w)
        local bufnr = api.nvim_win_get_buf(w)
        return vim.bo[bufnr].buftype == ""
    end)
end

---@type table<string, fun(bufnr?: integer, winnr?: integer, line?: integer): integer?>
M.switchbuf_winfn = {}

M.switchbuf_winfn.split = function()
    local prev_win = get_prev_win()

    return api.nvim_open_win(0, true, {
        split = "below",
        win = prev_win or 0,
    })
end

M.switchbuf_winfn.vsplit = function()
    local prev_win = get_prev_win()

    return api.nvim_open_win(0, true, {
        split = "right",
        win = prev_win or 0,
    })
end

M.switchbuf_winfn.newtab = function()
    -- Can't create a new tab with lua API
    -- https://github.com/neovim/neovim/pull/27223
    vim.cmd.tabnew()
    return api.nvim_get_current_win()
end

M.switchbuf_winfn.useopen = function(bufnr, winnr)
    if api.nvim_win_get_buf(winnr) == bufnr then
        return winnr
    end

    local windows = api.nvim_tabpage_list_wins(0)

    for _, win in ipairs(windows) do
        if api.nvim_win_get_buf(win) == bufnr then
            return win
        end
    end

    return nil
end

M.switchbuf_winfn.usetab = function(bufnr, winnr)
    if api.nvim_win_get_buf(winnr) == bufnr then
        return winnr
    end

    local tabs = { 0 }

    vim.list_extend(tabs, api.nvim_list_tabpages())

    for _, tabpage in ipairs(tabs) do
        for _, win in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
            if api.nvim_win_get_buf(win) == bufnr then
                api.nvim_set_current_tabpage(tabpage)
                return win
            end
        end
    end

    return nil
end

M.switchbuf_winfn.tabusevisible = function(bufnr, winnr, line)
    local cur_tab = api.nvim_win_get_tabpage(winnr)

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(cur_tab)) do
        if api.nvim_win_get_buf(win) == bufnr then
            local first = vim.fn.line("w0", win)
            local last = vim.fn.line("w$", win)
            if first <= line and line <= last then
                return win
            end
        end
    end

    return nil
end

M.switchbuf_winfn.uselast = function(_, winnr)
    local cur_buf = api.nvim_get_current_buf()

    local ok, is_source_buf = pcall(vim.api.nvim_buf_get_var, cur_buf, "dap_source_buf")

    is_source_buf = ok and is_source_buf

    if vim.bo[cur_buf].buftype == "" or is_source_buf then
        return winnr
    else
        local win = vim.fn.win_getid(vim.fn.winnr("#"))
        if win then
            return win
        end

        return nil
    end
end

return M
