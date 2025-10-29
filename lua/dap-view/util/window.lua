local api = vim.api

local M = {}

---@return integer?
M.fetch_window = function()
    for _, tabpage in ipairs(api.nvim_list_tabpages()) do
        for _, win in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
            if vim.w[win].dapview_win then
                return win
            end
        end
    end
end

return M
