---
title: Highlight Groups
---

`nvim-dap-view` defines 30 highlight groups linked to (somewhat) reasonable defaults, but they may look odd with your colorscheme. If the links aren't defined, no highlighting will be applied. To fix that, you have to manually define the highlight groups (see `:h nvim_set_hl()`). Consider contributing to your colorscheme by sending a PR to add support to `nvim-dap-view`!

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
