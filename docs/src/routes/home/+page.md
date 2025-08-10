---
title: NVIM DAP View
---

> Modern, minimalistic debugging UI for neovim

<video controls width="100%">
    <source src="videos/dv-demo.mp4" type="video/mp4" />
    <track kind="captions">
</video>

## Installation

:::info
**Requires neovim 0.11+**
:::

A nerd font is a soft requirement.

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

For a better experience, consider adding `nvim-dap-view` **as a dependency** for `nvim-dap`. [Why?](faq#why-add-nvim-dap-view-as-a-dependency-for-nvim-dap)

:::caution
If using a plugin that overrides the `'winbar'` option, make sure to disable it for `nvim-dap-view` [buffers](filetypes-autocmds).
:::

## Features

The plugin provides 8 "views" (aka "sections") that (mostly) share the same window (so there's clutter).

### Watches view

<img src="https://github.com/user-attachments/assets/381a5c9c-7eea-4cdc-8358-a2afe9f247b2" alt="watches view" />

Shows a list of user defined expressions, that are evaluated by debug adapter

- Basic CRUD operations for expressions
- Expand, collapse, copy or set the value of expressions and variables

### Threads view

<img src="https://i.ibb.co/CsNVQfzh/dap-view-threads.png" alt="threads view">

List all threads and their stack traces

- Jump to a function in the call stack, switching the context to that call
- Filter frames using Lua patterns
- Toggle `subtle` (hidden) frames

### Breakpoints view

<img src="https://github.com/user-attachments/assets/b8c23809-2f23-4a39-8aef-b880f2b3eef9" alt="breakpoints view" />

List all breakpoints with full syntax highlighting, including treesitter and semantic tokens (from LSP)

- Jump to the location of a brakpoint
- Delete a breakpoint

### Exceptions view

<img src="https://github.com/user-attachments/assets/86edd829-d9d8-4fae-b0c0-8b79339b0c33" alt="exceptions view" />

Control when the debugger should stop, outside of regular breakpoints (e.g., whenever an exception is thrown)

### Scopes view

<img src="https://github.com/user-attachments/assets/2628ae8e-9224-4b2f-94c7-88e7800c232b" alt="scopes view" />

Use the scopes widget provided by nvim-dap

### Sessions view

<img src="https://i.ibb.co/1fSHs7J1/image.png" alt="sessions view">

Use the sessions widget provided by nvim-dap (**disabled by default**)

### REPL view

<img src="https://github.com/user-attachments/assets/43caeb02-ff9e-47ea-a4c1-ab5dd30d8a3c" alt="repl view" />

Use REPL provided by nvim-dap

### Console view

You can also interact with the console (terminal), which is also provided by `nvim-dap`. By default, the console has its own window, but it can be configured to be shown with the other views. See details on the [config](configuration) page.

The console's default height is resized to match your `nvim-dap-view` configuration. You can also either completely [hide](hide-terminal) it (if it's not being used at all, which is the case for some debug adapters) or hide it only during session initialization (which is nice when debugging tests, for instance).

### Custom views

You can also write [your own](custom-views) views.

#### Disassembly view

A custom view is used to power the [disassembly view](disassembly), an integration with [nvim-dap-disasm](https://github.com/Jorenar/nvim-dap-disasm).

<img src="https://github.com/user-attachments/assets/97ed9e8c-20a0-4355-bb00-5199c7b3cd59" alt="disassembly view" />

### Control bar

`nvim-dap-view` also provides a "non view" component: the control bar, which exposes some clickable buttons to control your session. It's disabled by default. See details on how to enable and configure it [here](control-bar).

<img src="https://i.ibb.co/wNbqBnyN/image.png" alt="control bar">

## Usage

Learn about `nvim-dap-view`'s [commands](commands) and [keymaps](keymaps) to get started. If it's your first time setting up `nvim-dap`, start [here](basics). By default, `nvim-dap-view` **is not launched automatically** (i.e., when initializing a new session), you have to use the commands or the API. To change this behavior, enable the `auto_toggle` option.

## Customization

`nvim-dap-view` is fully customizable! Visit the [config](configuration) page to learn what you can do.
