local dap = require("dap")

local state = require("dap-view.state")

local M = {}

M.get_threads = function()
    local session = assert(dap.session(), "has active session")

    coroutine.wrap(function()
        local err, result = session:request("threads", {})

        state.threads_err = nil

        if err then
            state.threads_err = tostring(err)
            state.threads = {}
        elseif result then
            state.threads = result.threads
        end

        M.get_stack_frames(session)
    end)()
end

---@param session dap.Session
M.get_stack_frames = function(session)
    for _, thread in pairs(state.threads) do
        coroutine.wrap(function()
            local err, result = session:request("stackTrace", { threadId = thread.id })

            thread.err = nil

            if err then
                thread.err = tostring(err)
                thread.frames = {}
            elseif result then
                thread.frames = result.stackFrames
            end
        end)()
    end
end

return M
