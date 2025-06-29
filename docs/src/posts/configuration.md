---
title: Configuration
---

## Defaults

These are the default options from `nvim-dap-view`. You can use them as reference. You don't have to copy-paste them!

```lua
return {
    auto_toggle = false,
    winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        -- Must be one of the sections declared above (except for "console")
        default_section = "watches",
        headers = {
            breakpoints = "Breakpoints [B]",
            scopes = "Scopes [S]",
            exceptions = "Exceptions [E]",
            watches = "Watches [W]",
            threads = "Threads [T]",
            repl = "REPL [R]",
            console = "Console [C]",
        },
        controls = {
            enabled = false,
            position = "right",
            buttons = {
                "play",
                "step_into",
                "step_over",
                "step_out",
                "step_back",
                "run_last",
                "terminate",
                "disconnect",
            },
            custom_buttons = {},
            icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "",
                terminate = "",
                disconnect = "",
            },
        },
    },
    windows = {
        height = 12,
        position = "below",
        terminal = {
            position = "left",
            width = 0.5,
            -- List of debug adapters for which the terminal should be ALWAYS hidden
            hide = {},
            -- Hide the terminal when starting a new session
            start_hidden = false,
        },
    },
    help = {
        border = nil,
    },
    -- Controls how to jump when selecting a breakpoint or navigating the stack
    switchbuf = "usetab,newtab",
}
```
