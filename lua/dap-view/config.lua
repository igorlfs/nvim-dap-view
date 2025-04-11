local M = {}

---@class WinbarConfig
---@field sections SectionType[]
---@field default_section SectionType
---@field show boolean
---@field headers WinbarHeaders Header label for each section.

---@class WinbarHeaders
---@field breakpoints string
---@field scopes string
---@field exceptions string
---@field watches string
---@field threads string
---@field repl string
---@field console string

---@class TerminalConfig
---@field hide string[] Hide the terminal for listed adapters.
---@field position 'right' | 'left' | 'above' | 'below'
---@field width number
---@field start_hidden boolean

---@class WindowsConfig
---@field height integer
---@field terminal TerminalConfig

---@alias SectionType '"breakpoints"' | '"exceptions"' | '"watches"' | '"repl"' | '"threads"' | '"console"' | '"scopes"'

---@class Config
---@field winbar WinbarConfig
---@field windows WindowsConfig
---@field switchbuf string
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
