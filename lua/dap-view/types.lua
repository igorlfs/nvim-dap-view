---@class dapview.TerminalConfigPartial : dapview.TerminalConfig, {}

---@class dapview.WindowsConfigPartial: dapview.WindowsConfig, {}
---@field terminal? dapview.TerminalConfigPartial

---@class dapview.SectionConfigPartial : dapview.SectionConfig, {}

---@class dapview.IconsConfigPartial : dapview.IconsConfig, {}

---@class dapview.ControlsConfigPartial : dapview.ControlsConfig, {}

---@class dapview.WinbarConfigPartial : dapview.WinbarConfig, {}
---@field base_sections? table<dapview.Section,dapview.SectionConfigPartial>
---@field controls? dapview.ControlsConfigPartial

---@class dapview.RenderBreakpointsConfigPartial : dapview.RenderBreakpointsConfig, {}

---@class dapview.RenderThreadsConfigPartial : dapview.RenderThreadsConfig, {}

---@class dapview.RenderConfigPartial : dapview.RenderConfig, {}
---@field threads? dapview.RenderThreadsConfigPartial
---@field breakpoints? dapview.RenderBreakpointsConfigPartial

---@class dapview.HelpConfigPartial : dapview.HelpConfig, {}

---@class dapview.VirtualTextConfigPartial : dapview.VirtualTextConfig, {}

---@class dapview.HoverKeymapsConfigPartial : dapview.HoverKeymapsConfig, {}

---@class dapview.HelpKeymapsConfigPartial : dapview.HelpKeymapsConfig, {}

---@class dapview.ConsoleKeymapsConfigPartial : dapview.ConsoleKeymapsConfig, {}

---@class dapview.BaseKeymapsConfigPartial : dapview.BaseKeymapsConfig, {}

---@class dapview.KeymapsConfigPartial : dapview.KeymapsConfig, {}
---@field hover? dapview.HoverKeymapsConfigPartial
---@field help? dapview.HelpKeymapsConfigPartial
---@field console? dapview.ConsoleKeymapsConfigPartial
---@field base? dapview.BaseKeymapsConfigPartial

---@class dapview.Config : dapview.ConfigStrict, {}
---@field winbar? dapview.WinbarConfigPartial
---@field windows? dapview.WindowsConfigPartial
---@field render? dapview.RenderConfigPartial
---@field help? dapview.HelpConfigPartial
---@field icons? dapview.IconsConfigPartial
---@field virtual_text? dapview.VirtualTextConfigPartial
