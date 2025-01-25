---@class ConfigModule
local M = {}

---@class WinbarConfig
---@field sections SectionType[]
---@field default_section SectionType
---@field show boolean

---@class WindowsConfig
---@field height integer
---@field terminal TerminalConfig

---@class TerminalConfig
---@field position 'right' | 'left'

--- @alias SectionType '"breakpoints"' | '"exceptions"' | '"watches"' | '"repl"'

---@class Config
---@field winbar WinbarConfig
---@field windows WindowsConfig
M.config = {
    winbar = {
        show = true,
        sections = { "watches", "exceptions", "breakpoints", "repl" },
        default_section = "watches",
    },
    windows = {
        height = 12,
        terminal = {
            position = "left",
        },
    },
}

return M
