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
        end

        state.threads_err = nil

        if result then
            state.threads = result.threads
        end

        M.get_stack_frames()
    end)()
end

M.get_stack_frames = function()
    local session = assert(dap.session(), "has active session")

    for _, thread in pairs(state.threads) do
        coroutine.wrap(function()
            local err, result = session:request("stackTrace", { threadId = thread.id })

            if err then
                -- TODO
                return
            end

            if result then
                thread.frames = result.stackFrames
            end
        end)()
    end
end

return M
