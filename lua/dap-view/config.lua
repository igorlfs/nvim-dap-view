local M = {}

---@alias dapview.SectionType "breakpoints" | "exceptions" | "watches" | "repl" | "threads" | "console" | "scopes"

---@alias dapview.CustomButton string
---@alias dapview.DefaultButton "play" | "step_into" | "step_over" | "step_out" | "step_back" | "run_last" | "terminate" | "disconnect"
---@alias dapview.Button dapview.CustomButton | dapview.DefaultButton

---@class dapview.TerminalConfig
---@field hide string[] Hide the terminal for listed adapters.
---@field position 'right' | 'left' | 'above' | 'below'
---@field width number If > 1 number of columns, else percentage the terminal window should use
---@field start_hidden boolean Don't show the terminal window when starting a new session

---@class dapview.WindowsConfig
---@field height integer If > 1 number of lines, else percentage the windows should use
---@field position 'right' | 'left' | 'above' | 'below'
---@field anchor? fun(): integer? Function that returns a window number for the main nvim-dap-view window to follow
---@field terminal dapview.TerminalConfig

---@class dapview.WinbarHeaders
---@field breakpoints string
---@field scopes string
---@field exceptions string
---@field watches string
---@field threads string
---@field repl string
---@field console string

---@class dapview.ControlsIcons
---@field pause string
---@field play string
---@field step_into string
---@field step_over string
---@field step_out string
---@field step_back string
---@field run_last string
---@field terminate string
---@field disconnect string

---@class dapview.ControlButton
---@field render fun(): string Render the button (highlight and icon).
---@field action fun(clicks: integer, button: string, modifiers: string): nil Click handler. See `:help statusline`.

---@class dapview.ControlsConfig
---@field enabled boolean
---@field position 'left' | 'right'
---@field buttons dapview.Button[] Buttons to show in the controls section.
---@field custom_buttons table<dapview.CustomButton, dapview.ControlButton> Custom buttons to show in the controls section.
---@field icons dapview.ControlsIcons Icons for each button.

---@class dapview.WinbarConfig
---@field sections dapview.SectionType[]
---@field default_section dapview.SectionType
---@field show boolean
---@field headers dapview.WinbarHeaders Header label for each section.
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
            hide = {},
            width = 0.5,
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
