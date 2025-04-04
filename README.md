![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

# nvim-dap-view

> minimalistic [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) alternative

<https://github.com/user-attachments/assets/01c461f7-b77b-4232-bed5-4630f3e7c039>

<!--toc:start-->
- [nvim-dap-view](#nvim-dap-view)
    - [Installation](#installation)
        - [Via lazy.nvim](#via-lazynvim)
    - [Features](#features)
    - [Documentation](#documentation)
        - [Configuration](#configuration)
        - [Usage](#usage)
        - [Recommended Setup](#recommended-setup)
            - [Automatic Toggle](#automatic-toggle)
            - [Hide Terminal](#hide-terminal)
            - [Terminal Position and Integration](#terminal-position-and-integration)
            - [Expanding Variables](#expanding-variables)
        - [Highlight Groups](#highlight-groups)
        - [Filetypes and autocommands](#filetypes-and-autocommands)
    - [Roadmap](#roadmap)
    - [Non-goals](#non-goals)
    - [Known Issues](#known-issues)
    - [Acknowledgements](#acknowledgements)
<!--toc:end-->

> [!WARNING]  
> **Requires neovim 0.11+**

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

> [!NOTE]  
> `nvim-dap-view` heavily relies on the winbar option. If you're using a plugin that overrides it, consider disabling the plugin for `nvim-dap-view` buffers (e.g., [lualine](https://github.com/igorlfs/nvim-dap-view/issues/36))

## Features

The plugin provides 5 "views" that share the same window (so there's clutter)

- Watches view
    - Shows a list of (user defined) expressions, that are evaluated by the debug adapter
    - Add, edit and delete expressions from the watch list
        - Including adding the variable under the cursor

![watches view](https://github.com/user-attachments/assets/c6838700-95ed-4b39-9ab5-e0ed0e753995)

- Exceptions view
    - Control when the debugger should stop, outside of breakpoints (e.g.,
    whenever an exception is thrown, or when an exception is caught[^1]).
    - Toggle filter with `<CR>`

![exceptions view](https://github.com/user-attachments/assets/86edd829-d9d8-4fae-b0c0-8b79339b0c33)

- Breakpoints view
    - List all breakpoints
        - Uses syntax highlighting[^2]
        - Shows filename and number line
    - Jump to a breakpoint with `<CR>`

![breakpoints view](https://github.com/user-attachments/assets/b8c23809-2f23-4a39-8aef-b880f2b3eef9)

- Threads view
    - List all threads and their stack traces
    - Jump to a function in the call stack
    - Toggle `subtle` (hidden) frames with `t`

![threads view](https://github.com/user-attachments/assets/fb27d59b-30da-470f-a662-19940eae18a8)

- REPL view
    - Use REPL provided by nvim-dap

![REPL view](https://github.com/user-attachments/assets/43caeb02-ff9e-47ea-a4c1-ab5dd30d8a3c)

You can also interact with the console provided by `nvim-dap` (though, arguably, that's not a feature from `nvim-dap-view`). By the default, the console has its own window, but it can be configured to be shown with the other views, details on the [defaul config](#configuration) section.

The console's default size (height) is resized to match your `nvim-dap-view` configuration. You can also either completely [hide](#hide-terminal) it (if it's not being used at all) or hide it only during session initialization.

![console](https://github.com/user-attachments/assets/0980962c-e3da-4f16-af4c-786ef7fa4b18)

## Documentation

### Configuration

<details>
    <summary>Default options</summary>

```lua
return {
    winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { "watches", "exceptions", "breakpoints", "threads", "repl" },
        -- Must be one of the sections declared above
        default_section = "watches",
    },
    windows = {
        height = 12,
        terminal = {
            -- 'left'|'right'|'above'|'below': Terminal position in layout
            position = "left",
            -- List of debug adapters for which the terminal should be ALWAYS hidden
            hide = {},
            -- Hide the terminal when starting a new session
            start_hidden = false,
        },
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
to the watch list. The threads view has 2 mappings:

- `<CR>` jumps to a location in the call stack
- `t` toggles subtle frames

When you finish your session, you can use `:DapViewClose` to close the
`nvim-dap-view` window.

In total, there are 5 commands:

- `DapViewOpen`
- `DapViewClose`
- `DapViewToggle`
- `DapViewWatch`
- `DapViewJump [view]`

You can `:DapViewJump [view]` to jump directly to a view, from any window. For instance, to jump to the REPL, you can use `:DapViewJump repl` to jump to REPL.

Additionally, you can use `DapViewClose!` and `DapViewToggle!` to also hide the
terminal window, if you'd rather have a tidy view.

If you prefer using lua functions, I got you covered! The following provide the
same functionality as above:

```lua
require("dap-view").open()
require("dap-view").close()
require("dap-view").close(true) -- Same as `DapViewClose!`
require("dap-view").toggle()
require("dap-view").toggle(true) -- Same as `DapViewToggle!`
require("dap-view").add_expr()
require("dap-view").jump("[view]") -- Can be used to jump to a specific view, from any window
```

`nvim-dap-view` doesn't define any keybindings (outside its own buffer, of
course). An example for the toggle functionality, using the lua API:

```lua
vim.keymap.set("n", "<leader>v", function()
    require("dap-view").toggle()
end, { desc = "Toggle nvim-dap-view" })
```

### Recommended Setup

#### Automatic Toggle

If you find yourself constantly toggling `nvim-dap-view` once a session starts and then closing on session end, you might want to add the following snippet to your configuration:

```lua
local dap, dv = require("dap"), require("dap-view")
dap.listeners.before.attach["dap-view-config"] = function()
    dv.open()
end
dap.listeners.before.launch["dap-view-config"] = function()
    dv.open()
end
dap.listeners.before.event_terminated["dap-view-config"] = function()
    dv.close()
end
dap.listeners.before.event_exited["dap-view-config"] = function()
    dv.close()
end
```

#### Hide Terminal

Some debug adapters don't use the integrated terminal (console). To avoid having a useless window lying around, you can completely hide the terminal for them. To achieve that, add the following snippet to your `nvim-dap-view` setup:

```lua
-- Goes into your opts table (if using lazy.nvim), otherwise goes into the setup function
-- No need to include the "return" statement (or the outer curly braces)
return {
    windows = {
        terminal = {
            -- NOTE Don't copy paste this snippet
            -- Use the actual names for the adapters you want to hide
            -- `go` is known to not use the terminal.
            hide = { "go", "some-other-adapter" },
        },
    },
}
```

#### Terminal Position and Integration

When setting `windows.terminal.position` to `right` the views window may be used
to display the current breakpoint because `nvim-dap` defaults to the global
`switchbuf` setting.  A common solution is to set `switchbuf` to "useopen":

```lua
require("dap").defaults.fallback.switchbuf = "useopen"
```

If you are using an adapter that does not natively support the `nvim-dap` integrated
terminal, but you want to use the `nvim-dap-view` terminal anyway, you can get
the `winnr` and `bufnr` of the `nvim-dap-view` terminal via `dap-view.state` and
use `vim.fn.jobstart` to start your debug adapter in the `nvim-dap-view` terminal!
An example can be found [here](https://github.com/catgoose/nvim/blob/ffd88fd66ade9cad0da934e10308dbbfc76b9540/lua/config/dap/go.lua#L19-L48)

#### Expanding Variables

 `:DapViewWatch` expands the `<cexpr>` under the cursor (see `:h <cexpr>`). By default, this setting works really well for C-like languages, but it can be cumbersome for other languages. To handle that, you can tweak the value for the `iskeyword` option (see `:h iskeyword`).

### Highlight Groups

`nvim-dap-view` defines 10 highlight groups:

```
NvimDapViewMissingData
NvimDapViewWatchText
NvimDapViewWatchTextChanged
NvimDapViewExceptionFilterEnabled
NvimDapViewExceptionFilterDisabled
NvimDapViewFileName
NvimDapViewLineNumber
NvimDapViewSeparator
NvimDapViewThread
NvimDapViewThreadStopped
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

Missing something? Create an issue with a [feature
request](https://github.com/igorlfs/nvim-dap-view/issues/new?assignees=&labels=enhancement&projects=&template=feature_request.yml&title=feature%3A+)!

## Non-goals

Implement every feature from [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui). More specifically,

- **There will be no "scopes" view** (i.e., list all variables in scope). The rationale is that `nvim-dap` already provides a very nice UI for that, using widgets (see `:h dap-widgets`). The TLDR is that you can use

```lua
local widgets = require("dap.ui.widgets")
widgets.centered_float(widgets.scopes, { border = "rounded" })
```

to create a nice, centered floating window, where you can navigate and explore variables. A major advantage from this approach is that you're not limited to a small window at the bottom of your screen (which can be troublesome in noisy environments or languages).

![nvim-dap's Scopes widget](https://github.com/user-attachments/assets/f320392d-e0c8-4b70-8521-db97e115ef5e)

- Likewise, **there will be no "hover" view**, since that's also perfectly handled by `nvim-dap`'s widgets. You can use

```lua
require("dap.ui.widgets").hover(nil, { border = "rounded" })
```

to create a nice floating window to display the variable under the cursor.

![nvim-dap's Hover widget](https://github.com/user-attachments/assets/bdb29360-65dd-426f-b59b-fa0b61377e9c)

## Known Issues

- Breakpoints view doesn't show breakpoint conditions
    - That's a limitation with the current breakpoints API from `nvim-dap`. We
    could use a workaround, but a new API is
    [planned](https://github.com/mfussenegger/nvim-dap/issues/1388)

## Acknowledgements

- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) is obviously a huge inspiration!
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
- [blink.cmp](https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/config/utils.lua) for the config validation (which is partially taken from a PR to [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim/pull/934/files#diff-09ebcaa8c75cd1e92d25640e377ab261cfecaf8351c9689173fd36c2d0c23d94R16))

[^1]: Filters depend on the debug adapter's capabilities
[^2]: From treesitter and extmarks (e.g., semantic highlighting from LSP)
