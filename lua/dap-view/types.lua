---@class dapview.TerminalConfigPartial : dapview.TerminalConfig, {}

---@class dapview.WindowsConfigPartial: dapview.WindowsConfig, {}
---@field terminal? dapview.TerminalConfigPartial

---@class dapview.SectionConfigPartial : dapview.SectionConfig, {}

---@class dapview.DefaultButtonConfigPartial : dapview.DefaultButtonConfig, {}

---@class dapview.ControlsConfigPartial : dapview.ControlsConfig, {}
---@field base_buttons? table<dapview.DefaultButton, dapview.DefaultButtonConfigPartial>

---@class dapview.WinbarConfigPartial : dapview.WinbarConfig, {}
---@field base_sections? table<dapview.Section,dapview.SectionConfigPartial>
---@field controls? dapview.ControlsConfigPartial

---@class dapview.HelpConfigPartial : dapview.HelpConfig, {}

---@class dapview.Config : dapview.ConfigStrict, {}
---@field winbar? dapview.WinbarConfigPartial
---@field windows? dapview.WindowsConfigPartial
---@field help? dapview.HelpConfigPartial
