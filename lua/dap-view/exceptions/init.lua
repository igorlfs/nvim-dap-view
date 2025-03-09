local dap = require("dap")

local state = require("dap-view.state")

local M = {}

M.update_exception_breakpoints_filters = function()
    if vim.tbl_isempty(state.exceptions_options) then
        return
    end

    local filters = vim.iter(state.exceptions_options)
        :filter(function(x)
            return x.enabled
        end)
        :map(function(x)
            return x.exception_filter.filter
        end)
        :totable()

    dap.set_exception_breakpoints(filters)
end

return M
