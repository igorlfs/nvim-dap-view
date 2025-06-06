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
    if state.winnr and api.nvim_win_is_valid(state.winnr) then
        M.close(hide_terminal)
    else
        M.open()
    end
end

---@param hide_terminal? boolean
M.close = function(hide_terminal)
    if state.winnr and api.nvim_win_is_valid(state.winnr) then
        api.nvim_win_close(state.winnr, true)
    end
    state.winnr = nil
    if state.bufnr and api.nvim_buf_is_valid(state.bufnr) then
        api.nvim_buf_delete(state.bufnr, { force = true })
    end
    state.bufnr = nil
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

    local separate_term_win = not vim.tbl_contains(setup.config.winbar.sections, "console")
    local term_winnr = separate_term_win and term.open_term_buf_win()

    local is_term_win_valid = term_winnr and api.nvim_win_is_valid(term_winnr)

    local windows_config = setup.config.windows

    local term_position = require("dap-view.util").inverted_directions[windows_config.terminal.position]

    local anchor_win = windows_config.anchor and windows_config.anchor()
    local is_anchor_win_valid = anchor_win and api.nvim_win_is_valid(anchor_win)

    local winnr = api.nvim_open_win(bufnr, false, {
        split = (is_anchor_win_valid or is_term_win_valid) and term_position or windows_config.position,
        win = is_anchor_win_valid and anchor_win or is_term_win_valid and term_winnr or -1,
        height = windows_config.height < 1 and math.floor(vim.go.lines * windows_config.height)
            or windows_config.height,
    })

    assert(winnr ~= 0, "Failed to create nvim-dap-view window")

    state.winnr = winnr

    require("dap-view.views.options").set_options()
    require("dap-view.views.keymaps").set_keymaps()

    state.current_section = state.current_section or setup.config.winbar.default_section

    winbar.set_winbar_action_keymaps()
    winbar.show_content(state.current_section)

    -- Clean up states dap-view buffer is wiped out
    autocmd.quit_buf_autocmd(state.bufnr, function()
        -- The buffer is already being wiped out, so prevent close() from doing it again.
        state.bufnr = nil
        M.close()
    end)
end

---@param expr? string
M.add_expr = function(expr)
    local final_expr = expr or require("dap-view.util.exprs").get_current_expr()
    if require("dap-view.watches.actions").add_watch_expr(final_expr) then
        require("dap-view.views").switch_to_view(require("dap-view.watches.view").show)
    end
end

---@param view dapview.SectionType
M.jump_to_view = function(view)
    if not vim.tbl_contains(setup.config.winbar.sections, view) then
        vim.notify("Can't jump to unconfigured view: " .. view)
        return
    end
    if state.bufnr and state.winnr and api.nvim_win_is_valid(state.winnr) then
        api.nvim_set_current_win(state.winnr)
        winbar.show_content(view)
    else
        vim.notify("Can't jump to view: couldn't find the window")
    end
end

---@param view dapview.SectionType
M.show_view = function(view)
    if not vim.tbl_contains(setup.config.winbar.sections, view) then
        vim.notify("Can't show unconfigured view: " .. view)
        return
    end
    if state.current_section == view then
        M.jump_to_view(view)
    elseif state.bufnr and state.winnr and api.nvim_win_is_valid(state.winnr) then
        winbar.show_content(view)
    else
        vim.notify("Can't show view: couldn't find the window")
    end
end

return M
