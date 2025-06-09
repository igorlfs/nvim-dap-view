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

## Contributing

You can contribute in many ways:

- If you have any questions, create a [discussion](https://github.com/igorlfs/nvim-dap-view/discussions/new/choose).
- If something isn't working, create a [bug report](https://github.com/igorlfs/nvim-dap-view/issues/new?template=bug_report.yml).
- If you have an idea, file a [feature request](https://github.com/igorlfs/nvim-dap-view/issues/new?template=feature_request.yml). You can also go ahead and implement it yourself with a [PR](https://github.com/igorlfs/nvim-dap-view/compare).
- If you have some spare bucks, consider [sponsoring](https://github.com/sponsors/igorlfs).
