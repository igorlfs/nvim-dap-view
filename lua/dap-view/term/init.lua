local dap = require("dap")

local state = require("dap-view.state")
local winbar = require("dap-view.options.winbar")
local setup = require("dap-view.setup")
local util = require("dap-view.util")

local M = {}

local api = vim.api

---Hide the term win, does not affect the term buffer
M.hide_term_buf_win = function()
    if util.is_win_valid(state.term_winnr) then
        api.nvim_win_hide(state.term_winnr)
    end
end

---Open the term buf in a new window if
---I. A session is active (with a corresponding term buf)
---II. The adapter isn't configured to be hidden
---III. There's no term win or it is invalid
---@return integer?
M.open_term_buf_win = function()
    if not state.current_session_id then
        return nil
    end
    local term_bufnr = state.term_bufnrs[state.current_session_id]

    local windows_config = setup.config.windows
    local term_config = setup.config.windows.terminal

    local hide_adapter = vim.tbl_contains(term_config.hide, state.current_adapter)
    if term_bufnr and not hide_adapter and not util.is_win_valid(state.term_winnr) then
        local is_win_valid = util.is_win_valid(state.winnr)

        state.term_winnr = api.nvim_open_win(term_bufnr, false, {
            split = is_win_valid and term_config.position or windows_config.position,
            win = is_win_valid and state.winnr or -1,
            height = windows_config.height < 1 and math.floor(vim.go.lines * windows_config.height)
                or windows_config.height,
            width = term_config.width < 1 and math.floor(vim.go.columns * term_config.width)
                or term_config.width,
        })

        require("dap-view.term.options").set_win_options(state.term_winnr)
    end

    return state.term_winnr
end

---Create a term buf and setup nvim-dap's `terminal_win_cmd` to use it
M.setup_term_win_cmd = function()
    -- Can't use an unlisted term buffers
    -- See https://github.com/igorlfs/nvim-dap-view/pull/37#issuecomment-2785076872
    local term_bufnr = api.nvim_create_buf(true, false)

    assert(term_bufnr ~= 0, "Failed to create dap-view-term buffer")

    -- We have to set the filetype for each term buf to avoid issues when calling switch_term_buf
    -- See https://github.com/igorlfs/nvim-dap-view/issues/69
    vim.bo[term_bufnr].filetype = "dap-view-term"

    if vim.tbl_contains(setup.config.winbar.sections, "console") then
        winbar.set_winbar_action_keymaps(term_bufnr)
    end

    dap.defaults.fallback.terminal_win_cmd = function()
        return term_bufnr
    end

    return term_bufnr
end

M.switch_term_buf = function()
    local has_console = vim.tbl_contains(setup.config.winbar.sections, "console")
    local winnr = (has_console and state.winnr) or state.term_winnr
    local is_console_active = state.current_section == "console"

    if util.is_win_valid(winnr) and (is_console_active or not has_console) then
        ---@cast winnr integer

        api.nvim_win_call(winnr, function()
            api.nvim_set_current_buf(state.term_bufnrs[state.current_session_id])

            if is_console_active then
                winbar.update_section("console")
            end
        end)
    end
end

return M
