# nvim-dap-view

> minimalistic [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) alternative

<https://github.com/user-attachments/assets/f75bf535-1d9e-4070-8c7b-96026c343b47>

## Installation

> [!WARNING]  
> **Requires neovim 0.11+**

### Via lazy.nvim

```lua
return {
    {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
    },
}
```

## Features

- Watch expressions
- Manipulate breakpoints
- Navigate in the call stack
- Convenient wrapper around `nvim-dap` widgets (scopes) + REPL

All of that in a unified, unintrusive window.

## Documentation

Visit the full documentation on the [website](https://igorlfs.github.io/nvim-dap-view/home).
