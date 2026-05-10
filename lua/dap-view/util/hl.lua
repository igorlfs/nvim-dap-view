local state = require("dap-view.state")
local globals = require("dap-view.globals")

local M = {}

---@param hl_group string
---@param start [integer,integer]
---@param finish [integer,integer]
---@param bufnr integer?
M.hl_range = function(hl_group, start, finish, bufnr)
    vim.hl.range(bufnr or state.bufnr, globals.NAMESPACE, "NvimDapView" .. hl_group, start, finish)
end

M.types_to_hl_group = {
    boolean = "Boolean",
    bool = "Boolean",
    str = "String",
    string = "String",
    int = "Number",
    long = "Number",
    number = "Number",
    double = "Float",
    float = "Float",
    -- debugpy's "None"
    nonetype = "Constant",
    undefined = "Constant",
    ["nil"] = "Constant",
    ["function"] = "Function",
    asyncfunction = "Function",
}

---@param v dap.Variable|dap.EvaluateResponse
M.hl_from_variable = function(v)
    local hl = v.type and M.types_to_hl_group[v.type:lower()]

    if
        globals.HAS_0_12
        and hl
        and v.presentationHint
        and vim.tbl_contains(v.presentationHint.attributes or {}, "readOnly")
    then
        hl = hl .. "Dim"
    end

    return hl
end

return M
