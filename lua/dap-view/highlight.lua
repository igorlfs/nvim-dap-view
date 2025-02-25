local api = vim.api

---@param name string
---@param link string
local hl_create = function(name, link)
    api.nvim_set_hl(0, "NvimDapView" .. name, { link = link })
end

hl_create("MissingData", "DapBreakpoint")
hl_create("WatchText", "Comment")
hl_create("WatchTextChanged", "DiagnosticVirtualTextWarn")
hl_create("ExceptionFilterEnabled", "DiagnosticOk")
hl_create("ExceptionFilterDisabled", "DiagnosticError")
hl_create("FileName", "qfFileName")
hl_create("LineNumber", "qfLineNr")
hl_create("Separator", "Comment")
hl_create("Thread", "@namespace")
hl_create("ThreadStopped", "@conditional")
