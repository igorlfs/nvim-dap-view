local dap = require("dap")

local state = require("dap-view.state")
local setup = require("dap-view.setup")
local util_buf = require("dap-view.util.buffer")

local api = vim.api

local M = {}

M.close_term_buf_win = function()
    if state.term_winnr then
        api.nvim_win_close(state.term_winnr, true)
        state.term_winnr = nil
    end
    if state.term_bufnr then
        api.nvim_buf_delete(state.term_bufnr, { force = true })
        state.term_bufnr = nil
    end
end

M.term_buf_win_init = function()
    -- Should NOT close the term buffer, since it contains the data from the session

    if not state.term_bufnr then
        local term_bufnr = api.nvim_create_buf(true, false)

        assert(term_bufnr ~= 0, "Failed to create dap-view buffer")

        state.term_bufnr = term_bufnr
    end

    if not state.term_winnr then
        local config = setup.config
        local term_winnr = api.nvim_open_win(state.term_bufnr, false, {
            split = "below",
            win = -1,
            height = config.windows.height,
        })

        assert(term_winnr ~= 0, "Failed to create dap-view terminal window")

        state.term_winnr = term_winnr

        require("dap-view.term.options").set_options()

        util_buf.quit_buf_autocmd(state.term_bufnr, M.close_term_buf_win)

        dap.defaults.fallback.terminal_win_cmd = function()
            return state.term_bufnr, state.term_winnr
        end
    end

    return state.term_winnr
end

return M
