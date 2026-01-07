local state = require("dap-view.state")
local setup = require("dap-view.setup")

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

---Restores the configured size for a given window
---@param winnr integer
M.resize = function(winnr)
    local wo = vim.wo[winnr]

    local size_ = setup.config.windows.size
    local size__ = ((type(size_) == "function" and size_(state.win_pos)) or size_)

    ---@cast size__ number

    if wo.winfixheight then
        wo.winfixheight = false

        local size = math.floor(size__ < 1 and size__ * vim.go.lines or size__)

        api.nvim_win_set_height(state.term_winnr, size)

        wo.winfixheight = true
    end

    if wo.winfixwidth then
        wo.winfixwidth = false

        local size = math.floor(size__ < 1 and size__ * vim.go.columns or size__)

        api.nvim_win_set_width(state.term_winnr, size)

        wo.winfixwidth = true
    end
end

return M
