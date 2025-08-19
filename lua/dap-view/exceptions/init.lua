local dap = require("dap")

local state = require("dap-view.state")

local M = {}

M.update_exception_breakpoints_filters = function()
    local adapter_exception_options = state.exceptions_options[state.current_adapter] or {}
    if vim.tbl_isempty(adapter_exception_options) then
        return
    end

    local filters = vim.iter(adapter_exception_options)
        :filter(function(x)
            return x.enabled
        end)
        :map(function(x)
            return x.exception_filter.filter
        end)
        :totable()

    for _, session in pairs(dap.sessions()) do
        -- When switching to a new session, its initialization may not have finished yet
        -- Which makes the request to `setExceptionBreakpoints` fail
        -- (since `capabilities` will not be populated yet)
        -- To prevent that, only set the exception breakpoints for fully initialized sessions
        if session.config.type == state.current_adapter and session.initialized then
            session:set_exception_breakpoints(filters)
        end
    end
end

return M
