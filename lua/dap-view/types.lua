---@class dapview.TerminalConfigPartial : dapview.TerminalConfig, {}

---@class dapview.WindowsConfigPartial: dapview.WindowsConfig, {}
---@field terminal? dapview.TerminalConfigPartial

---@class dapview.SectionConfigPartial : dapview.SectionConfig, {}

---@class dapview.ButtonConfigPartial : dapview.ButtonConfig, {}

---@class dapview.ControlsIconsConfigPartial : dapview.ControlsIconsConfig, {}

---@class dapview.ControlsConfigPartial : dapview.ControlsConfig, {}
---@field icons? dapview.ControlsIconsConfigPartial Icons for each button

---@class dapview.WinbarConfigPartial : dapview.WinbarConfig, {}
---@field base_sections? table<dapview.Section,dapview.SectionConfig>
---@field controls? dapview.ControlsConfigPartial

---@class dapview.HelpConfigPartial : dapview.HelpConfig, {}

---@class dapview.Config : dapview.ConfigStrict, {}
---@field winbar? dapview.WinbarConfigPartial
---@field windows? dapview.WindowsConfigPartial
---@field help? dapview.HelpConfigPartial
