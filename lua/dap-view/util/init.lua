local api = vim.api

local M = {}

M.inverted_directions = {
    ["above"] = "below",
    ["below"] = "above",
    ["right"] = "left",
    ["left"] = "right",
}

M.is_buf_valid = function(bufnr)
    return bufnr and api.nvim_buf_is_valid(bufnr)
end

return M
