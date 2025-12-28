local globals = require("dap-view.globals")
local setup = require("dap-view.setup")
local state = require("dap-view.state")

local M = {}

local api = vim.api

-- From :h 'sessionoptions', only globals starting with an uppercase letter
-- (and containing at least a single lowercase letter) are restored
-- By using 'Dapview' (instead of 'DapView') we avoid potential conflicts with DAP
local SESSION_VARIABLES = {
    section = "DapviewSection",
    expr_count = "DapviewExprCount",
    watches = "DapviewWatches",
}

M.save_state = function()
    vim.g[SESSION_VARIABLES["section"]] = state.current_section

    -- We have to restore the `expr_count` so we can properly append new expressions
    -- (since the expression count is always incremented)
    vim.g[SESSION_VARIABLES["expr_count"]] = state.expr_count

    -- From :h 'sessionoptions', only string and number variables are stored
    -- No bother, converting to a string and back seems fine
    vim.g[SESSION_VARIABLES["watches"]] = vim.json.encode(state.watched_expressions)
end

-- This could be exposed, so people could force restoring the state
M.restore_state = function()
    state.current_section = vim.g[SESSION_VARIABLES["section"]]

    -- If config changes, the old session may no longer be enabled
    if not vim.tbl_contains(setup.config.winbar.sections, state.current_section) then
        state.current_section = setup.config.winbar.default_section
    end

    state.expr_count = vim.g[SESSION_VARIABLES["expr_count"]]

    state.watched_expressions = vim.json.decode(vim.g[SESSION_VARIABLES["watches"]] or "{}") or {}
end

M.load_session_hook = function()
    local restored = false

    for _, buf in ipairs(api.nvim_list_bufs()) do
        local name = api.nvim_buf_get_name(buf)

        -- The filetype information for the REPL may have been lost
        -- Likewise, a similar situation happens with the terminal
        if name == globals.MAIN_BUF_NAME or name:match("%[dap%-repl%-%d+%]$") or name:match("%[dap%-terminal%] ") then
            api.nvim_buf_delete(buf, { force = true })

            -- We may need to delete multiple buffers, but we only have to restore once
            if not restored then
                M.restore_state()

                -- Must schedule to properly restore breakpoints
                -- Otherwise might restore before the signs load
                -- NOTE: restoring the actual breakpoints is done by another plugin
                vim.schedule(function()
                    require("dap-view.actions").open()
                end)

                restored = true
            end
        end
    end
end

return M
