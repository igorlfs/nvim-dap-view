local M = {}

---@class WinbarConfig
---@field sections SectionType[]
---@field default_section SectionType
---@field show boolean

---@class TerminalConfig
---@field hide string[] Hide the terminal for listed adapters.
---@field position 'right' | 'left' | 'above' | 'below'
---@field start_hidden boolean

---@class WindowsConfig
---@field height integer
---@field terminal TerminalConfig

---@alias SectionType '"breakpoints"' | '"exceptions"' | '"watches"' | '"repl"' | '"threads"'

---@class Config
---@field winbar WinbarConfig
---@field windows WindowsConfig
M.config = {
    winbar = {
        show = true,
        sections = { "watches", "exceptions", "breakpoints", "threads", "repl" },
        default_section = "watches",
    },
    windows = {
        height = 12,
        terminal = {
            position = "left",
            hide = {},
            start_hidden = false,
        },
    },
}

return M
