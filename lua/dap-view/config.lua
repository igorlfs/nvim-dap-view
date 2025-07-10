local dap = require("dap")

local views = require("dap-view.views")
local controls_render = require("dap-view.options.controls.render")

local M = {}

---@alias dapview.CustomSection string
---@alias dapview.DefaultSection "breakpoints" | "exceptions" | "watches" | "repl" | "threads" | "console" | "scopes"
---@alias dapview.Section dapview.DefaultSection | dapview.CustomSection

---@alias dapview.CustomButton string
---@alias dapview.DefaultButton "play" | "step_into" | "step_over" | "step_out" | "step_back" | "run_last" | "terminate" | "disconnect"
---@alias dapview.Button dapview.CustomButton | dapview.DefaultButton

---@class dapview.TerminalConfig
---@field hide string[] List of adapters for which the terminal should be hidden
---@field position 'right' | 'left' | 'above' | 'below'
---@field width number If > 1 number of columns, else percentage the terminal window should use
---@field start_hidden boolean Don't show the terminal window when starting a new session

---@class dapview.WindowsConfig
---@field height integer If > 1 number of lines, else percentage the windows should use
---@field position 'right' | 'left' | 'above' | 'below'
---@field anchor? fun(): integer? Function that returns a window number for the main nvim-dap-view window to follow
---@field terminal dapview.TerminalConfig

---@class dapview.ButtonConfig
---@field render fun(): string Render the button (highlight and icon)
---@field action fun(clicks: integer, button: string, modifiers: string): nil Click handler. See `:help statusline`

---@class dapview.DefaultButtonConfig : dapview.ButtonConfig
---@field icons string[]

---@class dapview.ControlsConfig
---@field enabled boolean
---@field position 'left' | 'right'
---@field buttons dapview.Button[] Buttons to show in the controls section
---@field base_buttons table<dapview.DefaultButton, dapview.DefaultButtonConfig>
---@field custom_buttons table<dapview.CustomButton, dapview.ButtonConfig> Custom buttons to show in the controls section

---@class dapview.SectionConfig
---@field label string
---@field short_label string
---@field keymap string
---@field action fun(): nil

---@class dapview.WinbarConfig
---@field sections dapview.Section[]
---@field default_section dapview.Section
---@field show boolean
---@field base_sections table<dapview.Section,dapview.SectionConfig>
---@field custom_sections table<dapview.CustomSection, dapview.SectionConfig>
---@field controls dapview.ControlsConfig

---@class dapview.HelpConfig
---@field border? string|string[] Override `winborder`

---@class (exact) dapview.ConfigStrict
---@field winbar dapview.WinbarConfig
---@field windows dapview.WindowsConfig
---@field help dapview.HelpConfig
---@field switchbuf string Control how to jump when selecting a breakpoint or a call in the stack
---@field auto_toggle boolean

---@type dapview.ConfigStrict
M.config = {
    winbar = {
        show = true,
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        default_section = "watches",
        base_sections = {
            breakpoints = {
                keymap = "B",
                label = "Breakpoints [B]",
                short_label = " [B]",
                action = function()
                    views.switch_to_view("breakpoints")
                end,
            },
            scopes = {
                keymap = "S",
                label = "Scopes [S]",
                short_label = "󰂥 [S]",
                action = function()
                    views.switch_to_view("scopes")
                end,
            },
            exceptions = {
                keymap = "E",
                label = "Exceptions [E]",
                short_label = "󰢃 [E]",
                action = function()
                    views.switch_to_view("exceptions")
                end,
            },
            watches = {
                keymap = "W",
                label = "Watches [W]",
                short_label = "󰛐 [W]",
                action = function()
                    views.switch_to_view("watches")
                end,
            },
            threads = {
                keymap = "T",
                label = "Threads [T]",
                short_label = "󱉯 [T]",
                action = function()
                    views.switch_to_view("threads")
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
                    render = controls_render.play,
                    action = function()
                        local session = dap.session()
                        local action = session and not session.stopped_thread_id and dap.pause or dap.continue
                        action()
                    end,
                },
                step_into = {
                    icons = { "" },
                    render = controls_render.step_into,
                    action = function()
                        dap.step_into()
                    end,
                },
                step_over = {
                    icons = { "" },
                    render = controls_render.step_over,
                    action = function()
                        dap.step_over()
                    end,
                },
                step_out = {
                    icons = { "" },
                    render = controls_render.step_out,
                    action = function()
                        dap.step_out()
                    end,
                },
                step_back = {
                    icons = { "" },
                    render = controls_render.step_back,
                    action = function()
                        dap.step_back()
                    end,
                },
                run_last = {
                    icons = { "" },
                    render = controls_render.run_last,
                    action = function()
                        dap.run_last()
                    end,
                },
                terminate = {
                    icons = { "" },
                    render = controls_render.terminate,
                    action = function()
                        dap.terminate()
                    end,
                },
                disconnect = {
                    icons = { "" },
                    render = controls_render.disconnect,
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
            hide = {},
            start_hidden = false,
        },
    },
    help = {
        border = nil,
    },
    switchbuf = "usetab",
    auto_toggle = false,
}

return M
