local api = vim.api
local prefix = require("dap-view.globals").HL_PREFIX

---@param name string
---@param link string
local hl_create = function(name, link)
    api.nvim_set_hl(0, prefix .. name, { link = link })
end

local define_base_links = function()
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

    hl_create("Tab", "TabLine")
    hl_create("TabSelected", "TabLineSel")

    hl_create("ControlNC", "Comment")
    hl_create("ControlPlay", "@keyword")
    hl_create("ControlPause", "@boolean")
    hl_create("ControlStepInto", "@function")
    hl_create("ControlStepOut", "@function")
    hl_create("ControlStepOver", "@function")
    hl_create("ControlStepBack", "@function")
    hl_create("ControlRunLast", "@keyword")
    hl_create("ControlTerminate", "DapBreakpoint")
    hl_create("ControlDisconnect", "DapBreakpoint")
end

define_base_links()

api.nvim_create_autocmd("ColorScheme", {
    callback = define_base_links,
})
