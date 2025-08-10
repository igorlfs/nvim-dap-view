---
title: Highlight Groups
---

`nvim-dap-view` defines 30 highlight groups linked to (somewhat) reasonable defaults.

If the colors look odd with your colorscheme, consider submiting a PR to add support to `nvim-dap-view`!

If the links aren't defined at all, no highlighting will be applied. To fix that, you have to manually define the highlight groups (see `:help nvim_set_hl()`).

| Highlight Group                      | Default Link              |
| ------------------------------------ | ------------------------- |
| `NvimDapViewBoolean`                 | Boolean                   |
| `NvimDapViewControlDisconnect`       | DapBreakpoint             |
| `NvimDapViewControlNC`               | Comment                   |
| `NvimDapViewControlPause`            | Boolean                   |
| `NvimDapViewControlPlay`             | Keyword                   |
| `NvimDapViewControlRunLast`          | Keyword                   |
| `NvimDapViewControlStepBack`         | Function                  |
| `NvimDapViewControlStepInto`         | Function                  |
| `NvimDapViewControlStepOut`          | Function                  |
| `NvimDapViewControlStepOver`         | Function                  |
| `NvimDapViewControlTerminate`        | DapBreakpoint             |
| `NvimDapViewExceptionFilterDisabled` | DiagnosticError           |
| `NvimDapViewExceptionFilterEnabled`  | DiagnosticOk              |
| `NvimDapViewFileName`                | qfFileName                |
| `NvimDapViewFloat`                   | Float                     |
| `NvimDapViewFrameCurrent`            | DiagnosticVirtualTextWarn |
| `NvimDapViewFunction`                | Function                  |
| `NvimDapViewLineNumber`              | qfLineNr                  |
| `NvimDapViewMissingData`             | DapBreakpoint             |
| `NvimDapViewNumber`                  | Number                    |
| `NvimDapViewSeparator`               | Comment                   |
| `NvimDapViewString`                  | String                    |
| `NvimDapViewTabSelected`             | TabLineSel                |
| `NvimDapViewTab`                     | TabLine                   |
| `NvimDapViewThreadError`             | DiagnosticError           |
| `NvimDapViewThreadStopped`           | Conditional               |
| `NvimDapViewThread`                  | Tag                       |
| `NvimDapViewWatchError`              | DiagnosticError           |
| `NvimDapViewWatchExpr`               | Identifier                |
| `NvimDapViewWatchUpdated`            | DiagnosticVirtualTextWarn |
