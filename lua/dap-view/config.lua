local M = {}

---@alias dapview.CustomSection string
---@alias dapview.DefaultSection "breakpoints" | "exceptions" | "watches" | "repl" | "threads" | "console" | "scopes" | "sessions"
---@alias dapview.Section dapview.DefaultSection | dapview.CustomSection

---@alias dapview.CustomButton string
---@alias dapview.DefaultButton "play" | "step_into" | "step_over" | "step_out" | "step_back" | "run_last" | "terminate" | "disconnect"
---@alias dapview.Button dapview.CustomButton | dapview.DefaultButton

---@alias dapview.Position 'right' | 'left' | 'above' | 'below'

---@class dapview.Content
---@field part string
---@field hl? string|boolean
---@field separator? string

---@class dapview.TerminalConfig
---@field hide string[] List of adapters for which the terminal should be hidden
---@field position dapview.Position|fun(position: dapview.Position): dapview.Position Can be a function, receiving the main window's position as its argument
---@field size number|fun(position: dapview.Position): number Size of the terminal window's split. Either a number, where if > 1 it's the absolute size, or else the percentage. Can also be a function, receiving the position and returning a number, that then follows the same logic.

---@class dapview.WindowsConfig
---@field size number|fun(position: dapview.Position): number Size of the main window's split. Either a number, where if > 1 it's the absolute size, or else the percentage. Can also be a function, receiving the position and returning a number, that then follows the same logic.
---@field position dapview.Position|fun(prev_position?: dapview.Position): dapview.Position Position of the top level split. Can also be a function, receiving its previous position (if any) as its argument.
---@field anchor? fun(): integer? Function that returns a window number for the main nvim-dap-view window to treat as the terminal window
---@field terminal dapview.TerminalConfig

---@alias dapview.DefaultIcons dapview.DefaultButton | "pause"

---@class dapview.IconsConfig
---@field disabled string
---@field disconnect string
---@field enabled string
---@field filter string
---@field negate string
---@field pause string
---@field play string
---@field run_last string
---@field step_back string
---@field step_into string
---@field step_out string
---@field step_over string
---@field terminate string

---@class dapview.ButtonConfig
---@field render fun(session?: dap.Session): string Render the button (highlight and icon). Receives the current session as a param.
---@field action fun(clicks: integer, button: string, modifiers: string): nil Click handler. See `:help statusline`

---@class dapview.ControlsConfig
---@field enabled boolean
---@field position 'left' | 'right'
---@field buttons dapview.Button[] Buttons to show in the controls section
---@field custom_buttons table<dapview.CustomButton, dapview.ButtonConfig> Custom buttons to show in the controls section

---@class dapview.SectionConfig
---@field label string
---@field short_label string Label to be shown if there's not enough space to display the entire winbar
---@field keymap string

---@class dapview.CustomSectionConfig : dapview.SectionConfig
---@field action fun(): nil
---@field buffer fun(): integer Creates a new buffer for the section

---@class dapview.WinbarConfig
---@field sections dapview.Section[]
---@field default_section dapview.Section
---@field show boolean
---@field base_sections table<dapview.Section,dapview.SectionConfig>
---@field custom_sections table<dapview.CustomSection, dapview.CustomSectionConfig>
---@field controls dapview.ControlsConfig

---@class dapview.HelpConfig
---@field border? string|string[] Override `winborder` in the help window

---@class dapview.RenderThreadsConfig
---@field format fun(name: string, lnum: string, path: string): dapview.Content[]

---@class dapview.RenderConfig
---@field sort_variables? fun(lhs: dap.Variable, rhs: dap.Variable): boolean Override order of variables
---@field threads dapview.RenderThreadsConfig

---@class (exact) dapview.ConfigStrict
---@field winbar dapview.WinbarConfig
---@field windows dapview.WindowsConfig
---@field help dapview.HelpConfig
---@field render dapview.RenderConfig
---@field icons dapview.IconsConfig Icons for each button
---@field switchbuf string|dapview.SwitchBufFun Control how to jump when selecting a breakpoint or a call in the stack
---@field auto_toggle boolean|"keep_terminal"|"open_term"
---@field follow_tab boolean|fun(adapter?: string): boolean Reopen dapview when switching tabs

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
            },
            scopes = {
                keymap = "S",
                label = "Scopes [S]",
                short_label = "󰂥 [S]",
            },
            exceptions = {
                keymap = "E",
                label = "Exceptions [E]",
                short_label = "󰢃 [E]",
            },
            watches = {
                keymap = "W",
                label = "Watches [W]",
                short_label = "󰛐 [W]",
            },
            threads = {
                keymap = "T",
                label = "Threads [T]",
                short_label = "󱉯 [T]",
            },
            repl = {
                keymap = "R",
                label = "REPL [R]",
                short_label = "󰯃 [R]",
            },
            sessions = {
                keymap = "K", -- I ran out of mnemonics
                label = "Sessions [K]",
                short_label = " [K]",
            },
            console = {
                keymap = "C",
                label = "Console [C]",
                short_label = "󰆍 [C]",
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
            custom_buttons = {},
        },
    },
    windows = {
        size = 0.25,
        position = "below",
        terminal = {
            size = 0.5,
            position = "left",
            hide = {},
        },
    },
    icons = {
        disabled = "",
        disconnect = "",
        enabled = "",
        filter = "󰈲",
        negate = " ",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = "",
    },
    help = {
        border = nil,
    },
    render = {
        sort_variables = nil,
        threads = {
            format = function(name, lnum, path)
                return {
                    { part = name, separator = " " },
                    { part = path, hl = "FileName", separator = ":" },
                    { part = lnum, hl = "LineNumber" },
                }
            end,
        },
    },
    switchbuf = "usetab,uselast",
    auto_toggle = false,
    follow_tab = false,
}

return M
