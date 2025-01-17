![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

# nvim-dap-view

> minimalistic [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) alternative

![watches view](https://github.com/user-attachments/assets/c6838700-95ed-4b39-9ab5-e0ed0e753995)
![exceptions view](https://github.com/user-attachments/assets/86edd829-d9d8-4fae-b0c0-8b79339b0c33)
![breakpoints view](https://github.com/user-attachments/assets/b8c23809-2f23-4a39-8aef-b880f2b3eef9)

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
(even if not invoked), making the split take only 12 (configurable) screen lines.

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

The plugin provides 3 "views" that share the same window (so there's clutter)

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

## Documentation

### Configuration

<details>
    <summary>Default options</summary>

```lua
return {
    winbar = {
        show = true,
        sections = { "watches", "exceptions", "breakpoints" },
        -- Must be one of the sections declared above
        default_section = "watches",
    },
    windows = {
        height = 12,
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
    could use an workaround, but a new API is
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
