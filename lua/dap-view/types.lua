---@class dapview.TerminalConfigPartial : dapview.TerminalConfig, {}

---@class dapview.WindowsConfigPartial: dapview.WindowsConfig, {}
---@field terminal? dapview.TerminalConfigPartial

---@class dapview.WinbarHeadersPartial : dapview.WinbarHeaders, {}

---@class dapview.ControlsIconsPartial : dapview.ControlsIcons, {}

---@class dapview.ControlsConfigPartial : dapview.ControlButton, {}
---@field icons? dapview.ControlsIconsPartial Icons for each button

---@class dapview.WinbarConfigPartial : dapview.WinbarConfig, {}
---@field headers? dapview.WinbarHeadersPartial Header label for each section.
---@field controls? dapview.ControlsConfigPartial

---@class dapview.Config : dapview.ConfigStrict
---@field winbar? dapview.WindowsConfigPartial
---@field windows? dapview.WindowsConfigPartial
---@field switchbuf? string Control how to jump when selecting a breakpoint or a call in the stack
