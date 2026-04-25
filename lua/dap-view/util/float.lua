local M = {}

local fn = vim.fn

---@param width integer
M.get_anchor = function(width)
    local lines_above = fn.winline() - 1
    local lines_below = fn.winheight(0) - lines_above

    local anchor_below = lines_below > lines_above

    local anchor_y = anchor_below and "N" or "S"

    local wincol = fn.getmousepos().column

    local anchor_x = (wincol + width <= vim.o.columns) and "W" or "E"

    return anchor_y, anchor_x
end

return M
