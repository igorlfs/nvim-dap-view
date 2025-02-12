local dap = require("dap")

local winbar = require("dap-view.options.winbar")
local setup = require("dap-view.setup")
local util_buf = require("dap-view.util.buffer")
local term = require("dap-view.term.init")
local state = require("dap-view.state")
local settings = require("dap-view.options.settings")
local globals = require("dap-view.globals")
local expr = require("dap-view.watches.vendor.expr")

local api = vim.api

local M = {}

M.toggle = function()
    if state.bufnr then
        M.close()
    else
        M.open()
    end
end

M.close = function()
    if not dap.session() then
        term.close_term_buf_win()
        if vim.tbl_contains(setup.config.winbar.sections, "repl") then
            dap.repl.close()
        end
    end
    if state.winnr and api.nvim_win_is_valid(state.winnr) then
        api.nvim_win_close(state.winnr, true)
        state.winnr = nil
    end
    if state.bufnr then
        api.nvim_buf_delete(state.bufnr, { force = true })
        state.bufnr = nil
    end
end

M.open = function()
    M.close()

    local bufnr = api.nvim_create_buf(false, false)

    assert(bufnr ~= 0, "Failed to create dap-view buffer")

    state.bufnr = bufnr

    local prev_buf = require("dap-view.util").get_buf(globals.MAIN_BUF_NAME)
    if prev_buf then
        api.nvim_buf_delete(prev_buf, { force = true })
    end

    api.nvim_buf_set_name(bufnr, globals.MAIN_BUF_NAME)

    local term_winnr = term.term_buf_win_init()

    local config = setup.config

    local is_term_win_valid = term_winnr ~= nil and api.nvim_win_is_valid(term_winnr)

    local term_position = config.windows.terminal.position == "left" and "right" or "left"

    local winnr = api.nvim_open_win(bufnr, false, {
        split = is_term_win_valid and term_position or "below",
        win = is_term_win_valid and term_winnr or -1,
        height = config.windows.height,
    })

    assert(winnr ~= 0, "Failed to create dap-view window")

    state.winnr = winnr

    settings.set_options()
    settings.set_keymaps()

    state.current_section = state.current_section or config.winbar.default_section

    winbar.set_winbar_action_keymaps()
    winbar.show_content(state.current_section)

    -- Properly handle exiting the window
    util_buf.quit_buf_autocmd(state.bufnr, M.close)
end

M.add_expr = function()
    local expression = expr.eval_expression()
    require("dap-view.watches.actions").add_watch_expr(expression)

    require("dap-view.views").switch(require("dap-view.watches.view").show)
end

return M
