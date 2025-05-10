local M = {}

M.config = require("dap-view.config").config

---@param config dapview.Config?
M.setup = function(config)
    M.config = vim.tbl_deep_extend("force", M.config, config or {})

    require("dap-view.setup.validate").validate(M.config)
end

return M
