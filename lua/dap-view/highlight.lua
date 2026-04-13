local globals = require("dap-view.globals")

local api = vim.api

local has_0_12 = vim.fn.has("nvim-0.12") == 1

---@param name string
---@param link string?
---@param opts vim.api.keyset.highlight?
local hl_create = function(name, link, opts)
    api.nvim_set_hl(0, globals.HL_PREFIX .. name, opts or { default = true, link = link })
end

local define_base_links = function()
    hl_create("MissingData", "DapBreakpoint")
    hl_create("FileName", "qfFileName")
    hl_create("LineNumber", "qfLineNr")
    hl_create("Separator", "Comment")

    hl_create("Thread", "Tag")
    hl_create("ThreadStopped", "Conditional")
    hl_create("ThreadError", "DiagnosticError")

    hl_create("FrameCurrent", "DiagnosticVirtualTextWarn")

    hl_create("ExceptionFilterEnabled", "DiagnosticOk")
    hl_create("ExceptionFilterDisabled", "DiagnosticError")

    hl_create("Tab", "TabLine")
    hl_create("TabSeparator", "NvimDapViewTab")
    hl_create("TabSelected", "TabLineSel")
    hl_create("TabSelectedSeparator", "TabSelected")
    hl_create("TabFill", "TabLineFill")

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
    hl_create("Constant", "Constant")

    if not has_0_12 then
        return
    end

    hl_create("VirtualText", "NonText")
    hl_create("VirtualTextUpdated", "NvimDapViewWatchUpdated")
    hl_create("VirtualTextUpdated", nil, { dim = true, update = true })

    --TODO there's gotta be a cleaner way to this, right?
    hl_create("BooleanDim", "Boolean")
    hl_create("BooleanDim", nil, { dim = true, update = true })
    hl_create("StringDim", "String")
    hl_create("StringDim", nil, { dim = true, update = true })
    hl_create("NumberDim", "Number")
    hl_create("NumberDim", nil, { dim = true, update = true })
    hl_create("FloatDim", "Float")
    hl_create("FloatDim", nil, { dim = true, update = true })
    hl_create("FunctionDim", "Function")
    hl_create("FunctionDim", nil, { dim = true, update = true })
    hl_create("ConstantDim", "Constant")
    hl_create("ConstantDim", nil, { dim = true, update = true })
end

define_base_links()

api.nvim_create_autocmd("ColorScheme", {
    callback = define_base_links,
})
