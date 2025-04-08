local dap = require("dap")

local state = require("dap-view.state")
local autocmd = require("dap-view.options.autocmd")
local setup = require("dap-view.setup")

local M = {}

local api = vim.api

---Hide the term win, does not affect the term buffer
M.hide_term_buf_win = function()
    if state.term_winnr and api.nvim_win_is_valid(state.term_winnr) then
        api.nvim_win_hide(state.term_winnr)
    end
end

M.force_delete_term_buf = function()
    if state.term_bufnr then
        api.nvim_buf_delete(state.term_bufnr, { force = true })
    end
end

---Open the term buf in a new window if
---I. A session is active
---II. The term buf exists
---III. The adapter isn't configured to be hidden
---IV. There's no term win or it is invalid
---@return integer?
M.open_term_buf_win = function()
    local term_config = setup.config.windows.terminal
    local should_term_be_hidden = vim.tbl_contains(term_config.hide, state.last_active_adapter)

    if dap.session() and state.term_bufnr and not should_term_be_hidden then
        if not state.term_winnr or state.term_winnr and not api.nvim_win_is_valid(state.term_winnr) then
            local is_win_valid = state.winnr ~= nil and api.nvim_win_is_valid(state.winnr)

            state.term_winnr = api.nvim_open_win(state.term_bufnr, false, {
                split = is_win_valid and term_config.position or "below",
                win = is_win_valid and state.winnr or -1,
                height = setup.config.windows.height,
            })

            require("dap-view.term.options").set_options(state.term_winnr, state.term_bufnr)
        end
    end

    return state.term_winnr
end

local quit_term_buf = function()
    if state.term_bufnr then
        state.term_bufnr = nil
    end
end

---Create the term buf and setup nvim-dap's `terminal_win_cmd` to use it
M.setup_term_win_cmd = function()
    if not state.term_bufnr then
        -- Can't use an unlisted buffer here
        -- See https://github.com/igorlfs/nvim-dap-view/pull/37#issuecomment-2785076872
        state.term_bufnr = api.nvim_create_buf(true, false)

        assert(state.term_bufnr ~= 0, "Failed to create nvim-dap-view buffer")

        autocmd.quit_buf_autocmd(state.term_bufnr, quit_term_buf)

        dap.defaults.fallback.terminal_win_cmd = function()
            assert(state.term_bufnr, "Failed to get term bufnr")

            return state.term_bufnr
        end
    end
end

return M
