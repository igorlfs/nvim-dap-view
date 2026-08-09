local M = {}

local setup = require("dap-view.setup")
local state = require("dap-view.state")
local util = require("dap-view.util")

local go = vim.go

M.size = function()
    local windows_config = setup.config.windows
    local term_config = windows_config.terminal

    local is_anchor_win_valid = util.is_win_valid(state.anchor_winnr)
    local is_term_win_valid = util.is_win_valid(state.term_winnr)

    local position = windows_config.position
    local win_pos = (type(position) == "function" and position(state.win_pos))
        or (type(position) == "string" and position)

    ---@cast win_pos dapview.Position

    local is_vertical = win_pos == "above" or win_pos == "below"

    local term_position_ = term_config.position
    local term_win_pos = (type(term_position_) == "function" and term_position_(win_pos))
        or (type(term_position_) == "string" and term_position_)

    local inv_term_position = util.inverted_directions[term_win_pos]

    local term_size_ = term_config.size
    local term_size__ = (type(term_size_) == "function" and term_size_(inv_term_position)) or term_size_

    ---@cast term_size__ number

    local term_is_vertical = term_win_pos == "above" or term_win_pos == "below"

    local go_max = term_is_vertical and go.lines or go.columns

    local is_win_valid = is_anchor_win_valid or is_term_win_valid

    local size_ = windows_config.size
    local size__ = (type(size_) == "function" and size_(win_pos)) or size_

    ---@cast size__ number

    local size = size__ < 1 and math.floor((is_vertical and go.lines or go.columns) * size__) or size__

    local shared_split = term_is_vertical == is_vertical

    ---@cast term_size__ number

    if is_term_win_valid and shared_split and term_size__ < 1 then
        -- `size` is already an integer at this point
        term_size__ = term_size__ * size
    end

    local term_size = term_size__ < 1 and math.floor(go_max * term_size__) or math.floor(term_size__)

    -- Oh lord
    local height = (
        is_win_valid and (term_is_vertical and ((is_vertical and size or go.lines) - term_size) or size)
        or (is_vertical and size or nil)
    )
    local width = (
        is_win_valid and (not term_is_vertical and ((not is_vertical and size or go.columns) - term_size) or size)
        or (not is_vertical and size or nil)
    )

    return height, width
end

return M
