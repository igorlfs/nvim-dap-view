local dap = require("dap")

local winbar = require("dap-view.options.winbar")
local setup = require("dap-view.setup")
local autocmd = require("dap-view.options.autocmd")
local term = require("dap-view.term.init")
local state = require("dap-view.state")
local globals = require("dap-view.globals")

local M = {}

local api = vim.api

---@param hide_terminal? boolean
M.toggle = function(hide_terminal)
    if state.bufnr then
        M.close(hide_terminal)
    else
        M.open()
    end
end

---@param hide_terminal? boolean
M.close = function(hide_terminal)
    if vim.tbl_contains(setup.config.winbar.sections, "repl") then
        dap.repl.close()
    end
    if state.winnr and api.nvim_win_is_valid(state.winnr) then
        api.nvim_win_close(state.winnr, true)
        state.winnr = nil
    end
    if state.bufnr then
        api.nvim_buf_delete(state.bufnr, { force = true })
        state.bufnr = nil
    end
    if hide_terminal then
        term.hide_term_buf_win()
    end
end

M.open = function()
    M.close()

    local bufnr = api.nvim_create_buf(false, false)

    assert(bufnr ~= 0, "Failed to create nvim-dap-view buffer")

    state.bufnr = bufnr

    api.nvim_buf_set_name(bufnr, globals.MAIN_BUF_NAME)

    local term_winnr = term.open_term_buf_win()

    local is_term_win_valid = term_winnr ~= nil and api.nvim_win_is_valid(term_winnr)

    local term_position = require("dap-view.util").inverted_directions[setup.config.windows.terminal.position]

    local winnr = api.nvim_open_win(bufnr, false, {
        split = is_term_win_valid and term_position or "below",
        win = is_term_win_valid and term_winnr or -1,
        height = setup.config.windows.height,
    })

    assert(winnr ~= 0, "Failed to create nvim-dap-view window")

    state.winnr = winnr

    require("dap-view.views.options").set_options()
    require("dap-view.views.keymaps").set_keymaps()

    state.current_section = state.current_section or setup.config.winbar.default_section

    winbar.set_winbar_action_keymaps()
    winbar.show_content(state.current_section)

    -- Properly handle deleting the buffer
    autocmd.quit_buf_autocmd(state.bufnr, M.close)
end

M.add_expr = function()
    if require("dap-view.watches.actions").add_watch_expr(vim.fn.expand("<cexpr>")) then
        require("dap-view.views").switch_to_view(require("dap-view.watches.view").show)
    end
end

return M
