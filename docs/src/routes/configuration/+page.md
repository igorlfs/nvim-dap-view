---
title: Configuration
---

## Setup

The default configuration below is applied when the plugin is _loaded_ (**no `setup` call required**). You can tweak the options by calling `require"dap-view".setup(opts)` or using your plugin manager's features (e.g., `lazy.nvim`'s `opts`). Your options are **deep merged** with the defaults, so you only have to override what you actually want to change.

## Defaults

These are the default options for `nvim-dap-view`.

:::note
You don't have to copy and paste these options. Use them as a reference.
:::

```lua
return {
    winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        -- Must be one of the sections declared above
        default_section = "watches",
        -- Configure each section individually
        base_sections = {
            breakpoints = {
                keymap = "B",
                label = "Breakpoints [B]",
                short_label = " [B]",
                action = function()
                    require("dap-view.views").switch_to_view("breakpoints")
                end,
            },
            scopes = {
                keymap = "S",
                label = "Scopes [S]",
                short_label = "󰂥 [S]",
                action = function()
                    coroutine.wrap(function()
                        require("dap-view.views").switch_to_view("scopes")
                    end)()
                end,
            },
            exceptions = {
                keymap = "E",
                label = "Exceptions [E]",
                short_label = "󰢃 [E]",
                action = function()
                    require("dap-view.views").switch_to_view("exceptions")
                end,
            },
            watches = {
                keymap = "W",
                label = "Watches [W]",
                short_label = "󰛐 [W]",
                action = function()
                    require("dap-view.views").switch_to_view("watches")
                end,
            },
            threads = {
                keymap = "T",
                label = "Threads [T]",
                short_label = "󱉯 [T]",
                action = function()
                    require("dap-view.views").switch_to_view("threads")
                end,
            },
            repl = {
                keymap = "R",
                label = "REPL [R]",
                short_label = "󰯃 [R]",
                action = function()
                    require("dap-view.repl").show()
                end,
            },
            sessions = {
                keymap = "K", -- I ran out of mnemonics
                label = "Sessions [K]",
                short_label = " [K]",
                action = function()
                    require("dap-view.views").switch_to_view("sessions")
                end,
            },
            console = {
                keymap = "C",
                label = "Console [C]",
                short_label = "󰆍 [C]",
                action = function()
                    require("dap-view.views").switch_to_view("console")
                end,
            },
        },
        -- Add your own sections
        custom_sections = {},
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
        },
    },
    windows = {
        height = 0.25,
        position = "below",
        terminal = {
            width = 0.5,
            position = "left",
            -- List of debug adapters for which the terminal should be ALWAYS hidden
            hide = {},
            -- Hide the terminal when starting a new session
            start_hidden = true,
        },
    },
    icons = {
        disabled = "",
        disconnect = "",
        enabled = "",
        filter = "󰈲",
        negate = " ",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = "",
    },
    help = {
        border = nil,
    },
    -- Controls how to jump when selecting a breakpoint or navigating the stack
    -- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
    -- Only a subset of the options is available: newtab, useopen, usetab and uselast
    -- Can also be a function that takes the current winnr and the bufnr that will jumped to
    -- If a function, should return the winnr of the destination window
    switchbuf = "usetab,uselast",
    -- Auto open when a session is started and auto close when all sessions finish
    auto_toggle = false,
    -- Reopen dapview when switching to a different tab
    -- Can also be a function to dynamically choose when to follow, by returning a boolean
    -- If a function, receives the name of the adapter for the current session as an argument
    follow_tab = false,
}
```

If you would like to configure something that is not possible currently, open a [feature request](https://github.com/igorlfs/nvim-dap-view/issues/new?template=feature_request.yml).
