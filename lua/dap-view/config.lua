local M = {}

---@class WinbarConfig
---@field sections SectionType[]
---@field default_section SectionType
---@field show boolean
---@field headers WinbarHeaders Header label for each section.
---@field controls ControlsConfig

---@class WinbarHeaders
---@field breakpoints string
---@field scopes string
---@field exceptions string
---@field watches string
---@field threads string
---@field repl string
---@field console string

---@class ControlsConfig
---@field enabled boolean
---@field position 'left' | 'right'
---@field buttons Button[] Buttons to show in the controls section.
---@field custom_buttons table<CustomButton, ControlButton> Custom buttons to show in the controls section.
---@field icons ControlsIcons Icons for each button.

---@class ControlsIcons
---@field pause string
---@field play string
---@field step_into string
---@field step_over string
---@field step_out string
---@field step_back string
---@field run_last string
---@field terminate string
---@field disconnect string

---@class ControlButton
---@field render fun(): string Render the button (highlight and icon).
---@field action fun(clicks: integer, button: string, modifiers: string): nil Click handler. See `:help statusline`.

---@class TerminalConfig
---@field hide string[]? Hide the terminal for listed adapters.
---@field position? 'right' | 'left' | 'above' | 'below'
---@field width number?
---@field start_hidden boolean?

---@class WindowsConfig
---@field height integer?
---@field terminal TerminalConfig?

---@alias SectionType '"breakpoints"' | '"exceptions"' | '"watches"' | '"repl"' | '"threads"' | '"console"' | '"scopes"'

---@alias CustomButton string
---@alias DefaultButton '"play"' | '"step_into"' | '"step_over"' | '"step_out"' | '"step_back"' | '"run_last"' | '"terminate"' | '"disconnect"'
---@alias Button CustomButton | DefaultButton

---@class Config
---@field winbar WinbarConfig?
---@field windows WindowsConfig?
---@field switchbuf string?
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
        terminal = {
            position = "left",
            hide = {},
            width = 0.5,
            start_hidden = false,
        },
    },
    switchbuf = "usetab,newtab",
}

return M
