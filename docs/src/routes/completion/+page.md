---
title: Advanced completion
---

You can leverage `nvim-dap-view`'s completion capabilities to power `nvim-dap`'s built-in features.

The following examples use this helper function:

```lua
---@param line integer?
---@return dap.bp?
local function get_breakpoint_by_line(line)
    local line_ = line or api.nvim_win_get_cursor(0)[1]
    local buf = api.nvim_get_current_buf()
    local breakpoints = require("dap.breakpoints").get(buf)
    local breakpoint = vim.iter(breakpoints[buf] or {}):find(function(bp)
        return bp.line == line_
    end)

    return breakpoint
end
```

Works best with [`blink.cmp`](https://github.com/Saghen/blink.cmp).

### Conditional Breakpoints

```lua
vim.keymap.set("n", "<F21>", function()
    local default = get_breakpoint_by_line()

    vim.ui.input({
        prompt = "Breakpoint condition: ",
        -- Note that the function is not called directly
        completion = "customlist,v:lua.require'dap-view'.complete",
        default = default and default.condition,
    }, function(input)
        if input then
            require("dap").set_breakpoint(input)
        end
    end)
end)
```

### Log Points

Watch out, as log points don't work like regular breakpoints. Expressions within `{}` are interpolated, elsewhere text is interpreted literally.

```lua
vim.keymap.set("n", "<F8>", function()
    local default = get_breakpoint_by_line()

    vim.ui.input({
        prompt = "Log point message: ",
        completion = "customlist,v:lua.require'dap-view'.complete",
        default = default and default.logMessage,
    }, function(input)
        if input then
            require("dap").set_breakpoint(nil, nil, input)
        end
    end)
end)
```
