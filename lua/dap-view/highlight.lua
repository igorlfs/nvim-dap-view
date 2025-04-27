local globals = require("dap-view.globals")

local api = vim.api

---@param name string
---@param link string
local hl_create = function(name, link)
    api.nvim_set_hl(0, globals.HL_PREFIX .. name, { link = link })
end

local define_base_links = function()
    hl_create("MissingData", "DapBreakpoint")
    hl_create("FileName", "qfFileName")
    hl_create("LineNumber", "qfLineNr")
    hl_create("Separator", "Comment")
    hl_create("Thread", "Tag")
    hl_create("ThreadStopped", "Conditional")

    hl_create("ExceptionFilterEnabled", "DiagnosticOk")
    hl_create("ExceptionFilterDisabled", "DiagnosticError")

    hl_create("Tab", "TabLine")
    hl_create("TabSelected", "TabLineSel")

    hl_create("ControlNC", "Comment")
    hl_create("ControlPlay", "Keyword")
    hl_create("ControlPause", "Boolean")
    hl_create("ControlStepInto", "Function")
    hl_create("ControlStepOut", "Function")
    hl_create("ControlStepOver", "Function")
    hl_create("ControlStepBack", "Function")
    hl_create("ControlRunLast", "Keyword")
    hl_create("ControlTerminate", "DapBreakpoint")
    hl_create("ControlDisconnect", "DapBreakpoint")

    hl_create("WatchExpr", "Identifier")
    hl_create("WatchError", "DiagnosticError")
    hl_create("WatchUpdated", "DiagnosticVirtualTextWarn")

    hl_create("Boolean", "Boolean")
    hl_create("String", "String")
    hl_create("Number", "Number")
    hl_create("Float", "Float")
    hl_create("Function", "Function")
end

define_base_links()

api.nvim_create_autocmd("ColorScheme", {
    callback = define_base_links,
})
