local api = vim.api

local M = {}

---@param tabpage integer
---@param term? boolean
local fetch_win_from_tab = function(tabpage, term)
    for _, win in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
        if vim.w[win][term and "dapview_win_term" or "dapview_win"] then
            return win
        end
    end
end

---@param opts? {current_tab?: boolean, term?: boolean}
---@return integer?
M.fetch_window = function(opts)
    if opts and opts.current_tab then
        return fetch_win_from_tab(0, opts.term)
    end
    for _, tabpage in ipairs(api.nvim_list_tabpages()) do
        local win = fetch_win_from_tab(tabpage, opts and opts.term)
        if win then
            return win
        end
    end
end

return M
