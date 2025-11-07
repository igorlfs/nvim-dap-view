# nvim-dap-view

> minimalistic [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) alternative

<https://github.com/user-attachments/assets/e7d428f2-8361-4407-a4d0-5f3c4f97332e>

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
- Manage ongoing debug sessions
- Inspect all variables in scope[^1]
- REPL

All of that in a unified, unintrusive window.

## Getting Started

Start a regular debugging session. When desired, you can use `:DapViewOpen` to start the plugin. You can switch to another section using the letter outlined in the `'winbar'` (e.g., `B` for "Breakpoints"). Explore what you can do in each section by using `g?` to inspect the keymaps.

Once you're done debugging, you can close the plugin with `:DapViewClose` and then terminate your session as usual.

There's a lot more you can do: `nvim-dap-view` is highly customizable. To learn all the options, commands, tips and tricks, visit the full documentation on the [website](https://igorlfs.github.io/nvim-dap-view/home).

## Contributing

You can contribute in many ways:

- If you have any questions, create a [discussion](https://github.com/igorlfs/nvim-dap-view/discussions/new/choose).
- If something isn't working, create a [bug report](https://github.com/igorlfs/nvim-dap-view/issues/new?template=bug_report.yml).
- If you have an idea, file a [feature request](https://github.com/igorlfs/nvim-dap-view/issues/new?template=feature_request.yml). You can also go ahead and implement it yourself with a [PR](https://github.com/igorlfs/nvim-dap-view/compare).
- If you have some spare bucks, consider [sponsoring](https://github.com/sponsors/igorlfs).

[^1]: using nvim-dap's widgets
