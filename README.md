<div align="center">
    <img src="https://i.ibb.co/gbSZvN0S/logo.png" alt="logo" border="0"  width="200" height="200" />
</div>

# nvim-dap-view

> Modern debugging UI for neovim

<https://github.com/user-attachments/assets/357bb05d-5645-4cfc-9975-97313c57e770>

## Introduction

A UI for [`nvim-dap`](https://github.com/mfussenegger/nvim-dap) (the quasi canonical neovim implementation of [`DAP`](https://microsoft.github.io/debug-adapter-protocol/); the protocol that enhances text editors with IDE-like debugging capabilities).

## Installation

> [!WARNING]  
> **Requires neovim 0.11+**

### Via lazy.nvim

```lua
return {
    {
        "igorlfs/nvim-dap-view",
        -- let the plugin lazy load itself
        lazy = false,
        version = "1.*",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
    },
}
```

## Features

- Watch expressions

<img src="https://i.ibb.co/h1XpdNrm/image.png" alt="watches view" />

- Navigate in the call stack

<img src="https://i.ibb.co/MDGZZ4hn/image.png" alt="threads view" />

- Manipulate breakpoints

<img src="https://i.ibb.co/5hgCTCc1/image.png" alt="breakpoints view" />

- Inspect and modify variables in scope

<img src="https://i.ibb.co/3yvcM6tw/image.png" alt="scopes view" />

- REPL

<img src="https://i.ibb.co/XfcD5wtT/image.png" alt="repl view" />

- Inline virtual text variables

<img src="https://i.ibb.co/gb2sD9c0/image.png>" alt="image" />

- Hover

<img src="https://i.ibb.co/XhJB9jx/image.png" alt="image" />

- And more!

## Getting Started

Start a regular debugging session. When desired, you can use `:DapViewOpen` to start the plugin. You can switch to another section using the letter outlined in the `'winbar'` (e.g., `B` for "Breakpoints"). Explore what you can do in each section by using `g?` to inspect the keymaps.

Once you're done debugging, you can close the plugin with `:DapViewClose` and then terminate your session as usual.

There's a lot more you can do: `nvim-dap-view` is highly customizable. To learn all the options, commands, tips and tricks, visit the full documentation on the [website](https://igorlfs.github.io/nvim-dap-view/home).

## Contributing

You can contribute in many ways:

- If you have any questions, create a [discussion](https://github.com/igorlfs/nvim-dap-view/discussions/new/choose).
- If something isn't working, create a [bug report](https://github.com/igorlfs/nvim-dap-view/issues/new?template=bug_report.yml).
- If you have an idea, file a [feature request](https://github.com/igorlfs/nvim-dap-view/issues/new?template=feature_request.yml). You can also go ahead and implement it yourself with a [PR](https://github.com/igorlfs/nvim-dap-view/compare).
- If you have some spare bucks, consider becoming a [sponsor](https://github.com/sponsors/igorlfs).
