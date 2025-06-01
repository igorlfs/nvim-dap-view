local M = {}

local api = vim.api

M.inverted_directions = {
    ["above"] = "below",
    ["below"] = "above",
    ["right"] = "left",
    ["left"] = "right",
}

---@param bufnr integer
M.is_buf_valid = function(bufnr)
    return bufnr and api.nvim_buf_is_valid(bufnr)
end

---@param winnr integer
M.is_win_valid = function(winnr)
    return winnr and api.nvim_win_is_valid(winnr)
end

return M
