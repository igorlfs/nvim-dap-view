local views = require("dap-view.views")

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
---@field height number If > 1 number of lines, else percentage the windows should use
---@field position 'right' | 'left' | 'above' | 'below'
---@field anchor? fun(): integer? Function that returns a window number for the main nvim-dap-view window to follow
---@field terminal dapview.TerminalConfig

---@alias dapview.DefaultIcons dapview.DefaultButton | "pause"

---@class dapview.ControlsIconsConfig
---@field pause string
---@field play string
---@field step_into string
---@field step_over string
---@field step_out string
---@field step_back string
---@field run_last string
---@field terminate string
---@field disconnect string

---@class dapview.ButtonConfig
---@field render fun(session?: dap.Session): string Render the button (highlight and icon). Receives the current session as a param.
---@field action fun(clicks: integer, button: string, modifiers: string): nil Click handler. See `:help statusline`

---@class dapview.ControlsConfig
---@field enabled boolean
---@field position 'left' | 'right'
---@field buttons dapview.Button[] Buttons to show in the controls section
---@field custom_buttons table<dapview.CustomButton, dapview.ButtonConfig> Custom buttons to show in the controls section
---@field icons dapview.ControlsIconsConfig Icons for each button

---@class dapview.SectionConfig
---@field label string
---@field short_label string Label to be shown if there's not enough space to display the entire winbar
---@field keymap string
---@field action fun(): nil

---@class dapview.CustomSectionConfig : dapview.SectionConfig
---@field buffer fun(): integer Creates a new buffer for the section
---@field filetype string Filetype used by the section

---@class dapview.WinbarConfig
---@field sections dapview.Section[]
---@field default_section dapview.Section
---@field show boolean
---@field base_sections table<dapview.Section,dapview.SectionConfig>
---@field custom_sections table<dapview.CustomSection, dapview.CustomSectionConfig>
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
            icons = {
                play = "",
                pause = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "",
                terminate = "",
                disconnect = "",
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
