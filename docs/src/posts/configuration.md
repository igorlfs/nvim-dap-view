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
                    render = function(session)
                        local pausable = session and not session.stopped_thread_id
                        return statusline.hl(pausable and "" or "", pausable and "ControlPause" or "ControlPlay")
                    end,
                    action = function()
                        local session = dap.session()
                        local action = session and not session.stopped_thread_id and dap.pause or dap.continue
                        action()
                    end,
                },
                step_into = {
                    render = function(session)
                        local stopped = session and session.stopped_thread_id
                        return require("dap-view.util.statusline").hl(
                            "",
                            stopped and "ControlStepInto" or "ControlNC"
                        )
                    end,
                    action = function()
                        dap.step_into()
                    end,
                },
                step_over = {
                    render = function(session)
                        local stopped = session and session.stopped_thread_id
                        return require("dap-view.util.statusline").hl(
                            "",
                            stopped and "ControlStepOver" or "ControlNC"
                        )
                    end,
                    action = function()
                        dap.step_over()
                    end,
                },
                step_out = {
                    render = function(session)
                        local stopped = session and session.stopped_thread_id
                        return require("dap-view.util.statusline").hl(
                            "",
                            stopped and "ControlStepOut" or "ControlNC"
                        )
                    end,
                    action = function()
                        dap.step_out()
                    end,
                },
                step_back = {
                    render = function(session)
                        local stopped = session and session.stopped_thread_id
                        return require("dap-view.util.statusline").hl(
                            "",
                            stopped and "ControlStepBack" or "ControlNC"
                        )
                    end,
                    action = function()
                        dap.step_back()
                    end,
                },
                run_last = {
                    render = function()
                        return require("dap-view.util.statusline").hl("", "ControlRunLast")
                    end,
                    action = function()
                        dap.run_last()
                    end,
                },
                terminate = {
                    render = function(session)
                        return require("dap-view.util.statusline").hl(
                            "",
                            session and "ControlTerminate" or "ControlNC"
                        )
                    end,
                    action = function()
                        dap.terminate()
                    end,
                },
                disconnect = {
                    render = function(session)
                        return require("dap-view.util.statusline").hl(
                            "",
                            session and "ControlDisconnect" or "ControlNC"
                        )
                    end,
                    action = function()
                        dap.disconnect()
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
