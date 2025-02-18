local dap = require("dap")
local state = require("dap-view.state")

local M = {}

M.get_threads = function()
    local session = assert(dap.session(), "has active session")

    coroutine.wrap(function()
        local err, result = session:request("threads", {})

        if err then
            state.threads_err = tostring(err)
            return
        else
            state.threads_err = nil
        end

        state.threads = result.threads
    end)()
end

return M
