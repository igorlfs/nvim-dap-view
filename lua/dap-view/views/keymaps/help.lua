local setup = require("dap-view.setup")

local M = {}

local api = vim.api

---@param height integer
---@return integer,integer
local create_win = function(height)
    local help_buf = api.nvim_create_buf(true, false)

    local width = math.floor(vim.go.columns * 0.4)

    local help_win = api.nvim_open_win(help_buf, true, {
        relative = "editor",
        row = math.floor(vim.go.lines / 2 - height / 2 - 1),
        col = math.floor(vim.go.columns / 2 - width / 2 - 1),
        width = width,
        height = height,
        border = setup.config.help.border,
        style = "minimal",
        title = "Keymaps",
        title_pos = "center",
    })

    return help_buf, help_win
end

M.show_help = function()
    local content = {
        "## Scopes",
        "`<CR>`  Expand or collapse a variable",
        "   `o`  Trigger actions",
        "## Threads",
        "`<CR>`  Jump to a frame",
        "   `t`  Toggle subtle frames",
        "   `f`  Filter frames (via Lua patterns)",
        "   `o`  Omit results matching filter (invert filter)",
        "## Breakpoints",
        "`<CR>`  Jump to a breakpoint",
        "   `d`  Delete a breakpoint",
        "## Watches",
        "`<CR>`  Expand or collapse a variable",
        "   `i`  Insert an expression",
        "   `d`  Delete an expression",
        "   `e`  Edit an expression",
        "   `c`  Copy the value of an expression or variable",
        "   `s`  Set the value of an expression or variable",
        "## Exceptions",
        "`<CR>`  Toggle filter",
        "## Sessions",
        "`<CR>`  Switch to another session",
        "## Help",
        "   `q`  Close",
    }

    local help_buf, help_win = create_win(#content)

    vim.keymap.set("n", "q", function()
        api.nvim_win_close(help_win, true)
    end, { buffer = help_buf })

    api.nvim_buf_set_lines(help_buf, 0, -1, true, content)

    vim.treesitter.language.register("markdown", "dap-view-help")

    vim.bo[help_buf].filetype = "dap-view-help"
    vim.bo[help_buf].modifiable = false

    vim.wo[help_win][0].conceallevel = 2
    vim.wo[help_win][0].concealcursor = "nvc"

    vim.wo[help_win][0].cursorline = true
    vim.wo[help_win][0].cursorlineopt = "line"

    vim.wo[help_win][0].winfixbuf = true

    api.nvim_create_autocmd("WinClosed", {
        buffer = help_buf,
        callback = function()
            api.nvim_buf_delete(help_buf, { force = true })
        end,
    })
end

return M
