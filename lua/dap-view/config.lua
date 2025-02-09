---@class ConfigModule
local M = {}

---@class WinbarConfig
---@field sections SectionType[]
---@field default_section SectionType
---@field show boolean

---@class WindowsConfig
---@field height integer

---@class TerminalConfig
---@field exclude_adapters string[] Disable the terminal view for selected adapters.

---@alias SectionType '"breakpoints"' | '"exceptions"' | '"watches"' | '"repl"'

---@class Config
---@field winbar WinbarConfig
---@field windows WindowsConfig
---@field terminal TerminalConfig
M.config = {
    winbar = {
        show = true,
        sections = { "watches", "exceptions", "breakpoints", "repl" },
        default_section = "watches",
    },
    windows = {
        height = 12,
    },
    terminal = {
        exclude_adapters = {},
    },
}

return M
