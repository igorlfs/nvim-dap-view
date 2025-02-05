---@class ConfigModule
local M = {}

---@class WinbarConfig
---@field sections SectionType[]
---@field default_section SectionType
---@field show boolean

---@class WindowsConfig
---@field height integer
---@field width number|integer Width of the window in either characters or percentage (as decimal: 0.75). Window size of 1 means 100% width, which will hide the terminal window.
---@field position string By default the dap-view window will be opened to the right of the terminal. Should be left, right, above or below.

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
        width = 0.5,
        position = "right",
    },
}

return M
