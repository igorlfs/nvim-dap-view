---@class dapview.TerminalConfigPartial : dapview.TerminalConfig, {}

---@class dapview.WindowsConfigPartial: dapview.WindowsConfig, {}
---@field terminal? dapview.TerminalConfigPartial

---@class dapview.WinbarHeadersPartial : dapview.WinbarHeaders, {}

---@class dapview.ControlsIconsPartial : dapview.ControlsIcons, {}

---@class dapview.ControlsConfigPartial : dapview.ControlsConfig, {}
---@field icons? dapview.ControlsIconsPartial Icons for each button

---@class dapview.WinbarConfigPartial : dapview.WinbarConfig, {}
---@field headers? dapview.WinbarHeadersPartial Header label for each section.
---@field controls? dapview.ControlsConfigPartial

---@class dapview.HelpConfigPartial : dapview.HelpConfig, {}

---@class dapview.Config : dapview.ConfigStrict, {}
---@field winbar? dapview.WinbarConfigPartial
---@field windows? dapview.WindowsConfigPartial
---@field help? dapview.HelpConfigPartial
