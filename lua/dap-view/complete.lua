local setup = require("dap-view.setup")

local M = {}

---@param arg_lead string
---@return string[]
M.complete_sections = function(arg_lead)
    local sections = setup.config.winbar.sections
    return vim.iter(sections)
        :filter(function(section)
            return section:find(arg_lead or "") == 1
        end)
        :totable()
end

return M
