local M = {}

M.expect_stopped = function()
    local session = require("dap").session()

    if not session then
        vim.notify("No active session")
        return false
    end

    if not session.stopped_thread_id then
        vim.notify("No stopped thread")
    end

    return session.stopped_thread_id and true or false
end

return M
