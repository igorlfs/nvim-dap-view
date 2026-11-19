local M = {}

---@param silent? boolean
M.expect_stopped = function(silent)
    local session = require("dap").session()

    if not session then
        if not silent then
            vim.notify("No active session")
        end
        return false
    end

    if not session.stopped_thread_id and not silent then
        vim.notify("No stopped thread")
    end

    return session.stopped_thread_id and true or false
end

return M
