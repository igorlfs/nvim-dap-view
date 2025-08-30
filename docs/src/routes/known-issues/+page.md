---
title: Known Issues
---

## Limitations with the breakpoints view

- Doesn't show breakpoint conditions
- Isn't updated when there's no active session
- Can't "toggle" a breakpoint ([#74](https://github.com/igorlfs/nvim-dap-view/issues/74))

These limitations stem from `nvim-dap`'s breakpoints API (or more so, from the lack of a proper one). A new API is [planned](https://github.com/mfussenegger/nvim-dap/issues/1388).
