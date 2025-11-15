---@class dapview.TerminalConfigPartial : dapview.TerminalConfig, {}

---@class dapview.WindowsConfigPartial: dapview.WindowsConfig, {}
---@field terminal? dapview.TerminalConfigPartial

---@class dapview.SectionConfigPartial : dapview.SectionConfig, {}

---@class dapview.IconsConfigPartial : dapview.IconsConfig, {}

---@class dapview.ControlsConfigPartial : dapview.ControlsConfig, {}

---@class dapview.WinbarConfigPartial : dapview.WinbarConfig, {}
---@field base_sections? table<dapview.Section,dapview.SectionConfigPartial>
---@field controls? dapview.ControlsConfigPartial

---@class dapview.HelpConfigPartial : dapview.HelpConfig, {}

---@class dapview.RenderConfigPartial : dapview.RenderConfig, {}

---@class dapview.Config : dapview.ConfigStrict, {}
---@field winbar? dapview.WinbarConfigPartial
---@field windows? dapview.WindowsConfigPartial
---@field help? dapview.HelpConfigPartial
---@field icons? dapview.IconsConfigPartial
