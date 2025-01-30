![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

# nvim-dap-view

<!--toc:start-->
- [nvim-dap-view](#nvim-dap-view)
  - [Installation](#installation)
    - [Via lazy.nvim](#via-lazynvim)
  - [Features](#features)
  - [Documentation](#documentation)
    - [Configuration](#configuration)
    - [Usage](#usage)
    - [Highlight Groups](#highlight-groups)
    - [Filetypes and autocommands](#filetypes-and-autocommands)
  - [Roadmap](#roadmap)
  - [Known Issues](#known-issues)
  - [Acknowledgements](#acknowledgements)
<!--toc:end-->

> minimalistic [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) alternative

![watches view](https://github.com/user-attachments/assets/c6838700-95ed-4b39-9ab5-e0ed0e753995)
![exceptions view](https://github.com/user-attachments/assets/86edd829-d9d8-4fae-b0c0-8b79339b0c33)
![breakpoints view](https://github.com/user-attachments/assets/b8c23809-2f23-4a39-8aef-b880f2b3eef9)
![repl view](https://github.com/user-attachments/assets/43caeb02-ff9e-47ea-a4c1-ab5dd30d8a3c)

> [!WARNING]  
> **Currently requires a neovim nightly (0.11+)**

## Installation

### Via lazy.nvim

```lua
return {
    {
        "igorlfs/nvim-dap-view",
        opts = {},
    },
}
```

For a better experience, consider adding `nvim-dap-view` **as a dependency** for
`nvim-dap` (instead of declaring it as a standalone plugin)

<details>
    <summary>Why?</summary>

By default, when launching a session, `nvim-dap`'s terminal window takes half
the screen. As a saner default, `nvim-dap-view` hijacks the terminal window
(even if not invoked), making the split take only 12 (configurable) lines.

</details>

```lua
-- Your nvim-dap config
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "igorlfs/nvim-dap-view", opts = {} },
            ...,
        },
        ...,
    },
}
```

## Features

The plugin provides 4 "views" that share the same window (so there's clutter)

- Watches view
    - Shows a list of (user defined) expressions, that are evaluated by the debug adapter
    - Add, edit and delete expressions from the watch list
        - Including adding the variable under the cursor
- Exceptions view
    - Control when the debugger should stop, outside of breakpoints (e.g.,
    whenever an exception is thrown, or when an exception is caught[^1]).
    - Toggle filter with `<CR>`
- Breakpoints view
    - List all breakpoints
        - Uses syntax highlighting[^2]
        - Shows filename and number line
    - Jump to a breakpoint with `<CR>`
- REPL view
    - Use REPL provided by nvim-dap

You can also interact with the console provided by `nvim-dap` (though, arguably, that's not a feature from `nvim-dap-view`). The console has its own window. However, its default size (height) is resized to match you `nvim-dap-view` configuration.

![console](https://github.com/user-attachments/assets/0980962c-e3da-4f16-af4c-786ef7fa4b18)

## Documentation

### Configuration

<details>
    <summary>Default options</summary>

```lua
return {
    winbar = {
        show = true,
        sections = { "watches", "exceptions", "breakpoints", "repl" },
        -- Must be one of the sections declared above
        default_section = "watches",
    },
    windows = {
        height = 12,
        terminal = {
            position = "left" -- 'left'|'right': Terminal position in layout
        }
    },
}
```

</details>

### Usage

Start a regular debugging session. When desired, you can use `:DapViewOpen` to
start the plugin. You can switch to a view (section) using the letter outlined
in the `'winbar'` (e.g., `B` for the breakpoints view).

Both the breakpoints view and the exceptions view have only 1 mapping: `<CR>`.
It jumps to a breakpoint and toggles an exception filter, respectively. The
watches view comes with 3 mappings:

- `i` to insert a new expression
- `e` to edit an expression
- `d` to delete an expression

Though, the preferred way of adding a new expression is using the
`:DapViewWatch` command. In normal mode, it adds the variable under the cursor
to the watch list.

When you finish your session, you can use `:DapViewClose` to close the
`nvim-dap-view` window.

In total, there are 4 commands:

- `DapViewOpen`
- `DapViewClose`
- `DapViewToggle`
- `DapViewWatch`

If you prefer using lua functions, I got you covered! The following provide the
same functionality as above:

```lua
require("dap-view").open()
require("dap-view").close()
require("dap-view").toggle()
require("dap-view").add_expr()
```

`nvim-dap-view` doesn't define any keybindings (outside its own buffer, of
course). An example for the toggle functionality, using the lua API:

```lua
vim.keymap.set("n", "<leader>v", function()
    require("dap-view").toggle()
end, { desc = "Toggle nvim-dap-view" })
```

### Highlight Groups

`nvim-dap-view` defines 8 highlight groups:

```lua
NvimDapViewMissingData
NvimDapViewWatchText
NvimDapViewWatchTextChanged
NvimDapViewExceptionFilterEnabled
NvimDapViewExceptionFilterDisabled
NvimDapViewBreakpointFileName
NvimDapViewBreakpointLineNumber
NvimDapViewBreakpointSeparator
```

They are linked to (somewhat) reasonable defaults, but they may look odd with your colorscheme. Consider contributing to your colorscheme by sending a PR to add support to `nvim-dap-view`.

### Filetypes and autocommands

`nvim-dap-view` sets buffer filetypes for the following Views

| Window                           | Filetype      |
| -------------------------------- | ------------- |
| watches, exceptions, breakpoints | dap-view      |
| terminal                         | dap-view-term |

These filetypes can be used to override buffer and window options set by `nvim-dap-view`

<details>
    <summary>Example autocommand</summary>

Map q to quit in `nvim-dap-view` filetypes:

```lua
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
  callback = function(evt)
    vim.keymap.set("n", "q", "<C-w>q", { silent = true, buffer = evt.buf })
  end,
})
```

</details>

## Roadmap

- Watches
    - Actions
        - [ ] Expanding variables
        - [ ] Yank expression's value
- [ ] Threads and Stacks view

Missing something? Create an issue with a [feature
request](https://github.com/igorlfs/nvim-dap-view/issues/new?assignees=&labels=enhancement&projects=&template=feature_request.yml&title=feature%3A+)!

## Known Issues

- Breakpoints view doesn't show breakpoint conditions
    - That's a limitation with the current breakpoints API from `nvim-dap`. We
    could use a workaround, but a new API is
    [planned](https://github.com/mfussenegger/nvim-dap/issues/1388)

## Acknowledgements

- Code to inject treesitter highlights into line is taken from
[`quicker.nvim`](https://github.com/stevearc/quicker.nvim);
- Some snippets are directly extracted from `nvim-dap`:
    - Currently, there's no API to extract breakpoint information (see
    [issue](https://github.com/mfussenegger/nvim-dap/issues/1388)), so we
    resort to using nvim-dap internal mechanism, that tracks extmarks;
    - The magic to extract expressions from visual mode is also a courtesy of
    `nvim-dap`.
- [lucaSartore](https://github.com/lucaSartore/nvim-dap-exception-breakpoints)
for the inspiration for handling breakpoint exceptions;
- [Kulala](https://github.com/mistweaverco/kulala.nvim) for the creative usage
of neovim's `'winbar'` to handle multiple views.

[^1]: Filters depend on the debug adapter's capabilities
[^2]: From treesitter and extmarks (e.g., semantic highlighting from LSP)
