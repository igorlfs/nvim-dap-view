local M = {}

local api = vim.api

---@type table<string, fun(bufnr?: integer, winnr?: integer, line?: integer): integer?>
M.switchbuf_winfn = {}

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

M.switchbuf_winfn.uselast = function(_, winnr)
    local cur_buf = api.nvim_get_current_buf()

    if vim.bo[cur_buf].buftype == "" then
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
