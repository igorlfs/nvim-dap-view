---
title: Known Issues
---

## Limitations with the breakpoints view

- Doesn't show breakpoint conditions
- Isn't updated when there's no active session
- Can't "toggle" a breakpoint ([#74](https://github.com/igorlfs/nvim-dap-view/issues/74))

These are limitations with the current API from `nvim-dap`. A new API is [planned](https://github.com/mfussenegger/nvim-dap/issues/1388).

## The terminal buffer is cleared right after a session finishes

Due to a limitation in the way multisession support is currently implemented, it's necessary to eagerly close buffers. Read [this](https://github.com/mfussenegger/nvim-dap/discussions/1523) discussion for details.
