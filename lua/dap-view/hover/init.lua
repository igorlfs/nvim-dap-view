local state = require("dap-view.state")
local setup = require("dap-view.setup")

local keymap = require("dap-view.views.keymaps.util").keymap

local M = {}

local api = vim.api

---@param winnr integer
M.set_win_options = function(winnr)
    local win = vim.wo[winnr][0]

    win.winfixbuf = true
    win.statuscolumn = ""
    win.foldcolumn = "0"
    win.number = false
    win.relativenumber = false

    -- If not focused, NormalFloat won't be applied right away
    win.winhighlight = "Normal:NormalFloat"
end

---@param bufnr integer
M.set_buf_options = function(bufnr)
    local buf = vim.bo[bufnr]

    buf.buftype = "nofile"
    buf.modifiable = false
    buf.swapfile = false
    buf.filetype = "dap-view-hover"
end

---@param buffer integer
M.set_keymaps = function(buffer)
    local keys = setup.config.keymaps.hover

    keymap(keys.quit, "<C-w>q", { buffer = buffer, desc = "close" })

    keymap(keys.toggle, function()
        local cursor_line = api.nvim_win_get_cursor(state.hover_winnr)[1]

        coroutine.wrap(function()
            if require("dap-view.hover.actions").expand_or_collapse(cursor_line) then
                require("dap-view.hover.eval").evaluate_expression(state.hover)

                local line, width = unpack(require("dap-view.hover.view").show(buffer))

                api.nvim_win_set_height(state.hover_winnr, line)
                api.nvim_win_set_width(state.hover_winnr, width)
            end
        end)()
    end, { buffer = buffer, desc = "toggle" })

    keymap(keys.jump_to_parent, function()
        local cursor_line = api.nvim_win_get_cursor(state.hover_winnr)[1]

        require("dap-view.hover.actions").jump_to_parent(cursor_line)
    end, { buffer = buffer, desc = "jump to parent" })

    keymap(keys.set_value, function()
        local cursor_line = api.nvim_win_get_cursor(state.hover_winnr)[1]

        coroutine.wrap(function()
            if require("dap-view.hover.actions").set_hover_expr(cursor_line) then
                -- This is a little redundant
                require("dap-view.hover.eval").evaluate_expression(state.hover)

                local line, width = unpack(require("dap-view.hover.view").show(buffer))

                api.nvim_win_set_height(state.hover_winnr, line)
                api.nvim_win_set_width(state.hover_winnr, width)
            end
        end)()
    end, { buffer = buffer, desc = "set value" })
end

---@param bufnr integer
M.set_autocmds = function(bufnr)
    api.nvim_create_autocmd("BufLeave", {
        buf = bufnr,
        callback = function()
            api.nvim_buf_delete(bufnr, { force = true })

            for k, _ in pairs(state.hover_path_is_expanded) do
                state.hover_path_is_expanded[k] = nil
            end
            for k, _ in pairs(state.hover_path_to_value) do
                state.hover_path_to_value[k] = nil
            end
            for k, _ in pairs(state.hover_path_to_parent_reference) do
                state.hover_path_to_parent_reference[k] = nil
            end
            for k, _ in pairs(state.hover_path_to_name) do
                state.hover_path_to_name[k] = nil
            end
            for k, _ in pairs(state.hover_path_to_evaluate_name) do
                state.hover_path_to_evaluate_name[k] = nil
            end
            for k, _ in pairs(state.line_to_hover_path) do
                state.line_to_hover_path[k] = nil
            end
            for k, _ in pairs(state.hover_path_to_parent_line) do
                state.hover_path_to_parent_line[k] = nil
            end

            state.hovered_expression = nil
            state.hover = nil

            state.hover_winnr = nil
            state.hover_bufnr = nil
        end,
    })
end

return M
