---
title: Configuration
---

## Defaults

These are the default options from `nvim-dap-view`. You can use them as reference. You don't have to copy-paste them.

```lua
return {
    winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        -- Must be one of the sections declared above (except for "console")
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
                    require("dap-view.views").switch_to_view("scopes")
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
            console = {
                keymap = "C",
                label = "Console [C]",
                short_label = "󰆍 [C]",
                action = function()
                    require("dap-view.term").show()
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
            base_buttons = {
                play = {
                    icons = { "", "" },
                    -- Check the source to learn how the render functions work
                    render = require("dap-view.options.controls.render").play,
                    -- Pauses if running, else continues
                    action = function()
                        local session = require("dap").session()
                        local action = session and not session.stopped_thread_id and require("dap").pause
                            or require("dap").continue
                        action()
                    end,
                },
                step_into = {
                    icons = { "" },
                    render = require("dap-view.options.controls.render").step_into,
                    action = function()
                        require("dap").step_into()
                    end,
                },
                step_over = {
                    icons = { "" },
                    render = require("dap-view.options.controls.render").step_over,
                    action = function()
                        require("dap").step_over()
                    end,
                },
                step_out = {
                    icons = { "" },
                    render = require("dap-view.options.controls.render").step_out,
                    action = function()
                        require("dap").step_out()
                    end,
                },
                step_back = {
                    icons = { "" },
                    render = require("dap-view.options.controls.render").step_back,
                    action = function()
                        require("dap").step_back()
                    end,
                },
                run_last = {
                    icons = { "" },
                    render = require("dap-view.options.controls.render").run_last,
                    action = function()
                        require("dap").run_last()
                    end,
                },
                terminate = {
                    icons = { "" },
                    render = require("dap-view.options.controls.render").terminate,
                    action = function()
                        require("dap").terminate()
                    end,
                },
                disconnect = {
                    icons = { "" },
                    render = require("dap-view.options.controls.render").disconnect,
                    action = function()
                        require("dap").disconnect()
                    end,
                },
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
            start_hidden = false,
        },
    },
    help = {
        border = nil,
    },
    -- Controls how to jump when selecting a breakpoint or navigating the stack
    switchbuf = "usetab",
    auto_toggle = false,
}
```
