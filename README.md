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
            - [Jumping](#jumping)
            - [Expanding Variables](#expanding-variables)
        - [Highlight Groups](#highlight-groups)
        - [Filetypes and Autocommands](#filetypes-and-autocommands)
        - [Custom Buttons](#custom-buttons)
    - [Roadmap](#roadmap)
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
> `nvim-dap-view` heavily relies on the winbar option. If you're using a plugin that overrides it, consider disabling the plugin for `nvim-dap-view` [buffers](#filetypes-and-autocommands) (e.g., [lualine](https://github.com/igorlfs/nvim-dap-view/issues/36))

## Features

The plugin provides 6 "views" that share the same window (so there's clutter)

- Watches view
    - Shows a list of user defined expressions, that are evaluated by the debug adapter
    - Add, edit and delete expressions from the watch list
        - Add variable under the cursor using a command
    - Expand and collapse expressions and variables
    - Set the value of an expression or variable (if supported by debug adapter)
    - Copy the value of an expression or variable

![watches view](https://github.com/user-attachments/assets/381a5c9c-7eea-4cdc-8358-a2afe9f247b2)

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

- Scopes view
    - Use the scopes widget provided by nvim-dap
        - Expand variables with `<CR>`

![scopes view](https://github.com/user-attachments/assets/2628ae8e-9224-4b2f-94c7-88e7800c232b)

You can also interact with the console, which is also provided by `nvim-dap`. By the default, the console has its own window, but it can be configured to be shown with the other views. See details on the [default config](#configuration) section.

The console's default size (height) is resized to match your `nvim-dap-view` configuration. You can also either completely [hide](#hide-terminal) it (if it's not being used at all) or hide it only during session initialization.

![console](https://github.com/user-attachments/assets/0980962c-e3da-4f16-af4c-786ef7fa4b18)

You can also enable the control bar which exposes some clickable buttons by settings `winbar.controls.enable`.
The control bar is fully customizable, checkout the options on default configuration section.

![controls](https://github.com/user-attachments/assets/3d8d7102-7183-4acf-9759-6a7c7b354e9a)

>[!NOTE]
> Icons are using `Codicons` glyphs so it requires a Nerd Font

## Documentation

### Configuration

<details>
    <summary>Default options</summary>

```lua
return {
    winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        -- Must be one of the sections declared above
        default_section = "watches",
        headers = {
            breakpoints = "Breakpoints [B]",
            scopes = "Scopes [S]",
            exceptions = "Exceptions [E]",
            watches = "Watches [W]",
            threads = "Threads [T]",
            repl = "REPL [R]",
            console = "Console [C]",
        },
        controls = {
            enabled = false,
            position = "right",
            buttons = {
                "play",
                "step_into",
                "step_over",
                "step_out",
                "step_back",
                "run_last",
                "terminate",
                "disconnect",
            },
            icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "",
                terminate = "",
                disconnect = "",
            },
            custom_buttons = {},
        },
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
    -- Controls how to jump when selecting a breakpoint or navigating the stack
    switchbuf = "usetab,newtab",
}
```

</details>

### Usage

Start a regular debugging session. When desired, you can use `:DapViewOpen` to
start the plugin. You can switch to a view (section) using the letter outlined
in the `'winbar'` (e.g., `B` for the breakpoints view).

The breakpoints view and the exceptions view only have 1 mapping: `<CR>`. It jumps to a breakpoint and toggles an exception filter, respectively. The watches view comes with 6 mappings:

- `<CR>` to expand or collapse a variable
- `i` to insert a new expression
- `e` to edit an expression
- `c` to copy an expression or variable
- `s` to set (change) the value of an expression or variable
- `d` to delete an expression

Though, the preferred way of adding a new expression is using the
`:DapViewWatch` command. In normal mode, it adds the variable under the cursor
to the watch list. The threads view has 2 mappings:

- `<CR>` jumps to a location in the call stack
- `t` toggles subtle frames

Similarly, the scopes view comes with 2 mappings:

- `<CR>` to expand or collapse a variable
- `o` to open a menu with further actions

When you finish your session, you can use `:DapViewClose` to close the
`nvim-dap-view` window.

In total, there are 6 commands:

- `DapViewOpen`
- `DapViewClose`
- `DapViewToggle`
- `DapViewWatch`
- `DapViewJump [view]`
- `DapViewShow [view]`

You can `:DapViewJump [view]` to jump directly to a view, from any window. For instance, to jump to the REPL, you can use `:DapViewJump repl`.

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
-- Can be used to jump to a specific view, from any window
require("dap-view").jump_to_view("[view]")
-- Can be used to show to a specific view
-- If the specified view is the current one, jump to its window instead
require("dap-view").show_view("[view]")
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
-- No need to include the "return" statement
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

#### Jumping

When setting `windows.terminal.position` to `right`, `nvim-dap-view`'s main window may be used to display the current frame (after execution stops), because `nvim-dap` defaults to the global `switchbuf` setting. To address this, update your `switchbuf` configuration. For instance:

```lua
require("dap").defaults.fallback.switchbuf = "useopen" -- See :h dap-defaults to learn more
```

When jumping via `nvim-dap-view` (to a breakpoint or to a frame in the stack), `nvim-dap-view` uses its own `switchbuf`, which supports a subset of the default neovim options ("newtab", "useopen", "usetab" and "uselast"). You can customize it with:

```lua
-- Goes into your opts table (if using lazy.nvim), otherwise goes into the setup function
-- No need to include the "return" statement
return {
    switchbuf = "useopen",
}
```

#### Expanding Variables

 `:DapViewWatch` expands the `<cexpr>` under the cursor (see `:h <cexpr>`). By default, this setting works really well for C-like languages, but it can be cumbersome for other languages. To handle that, you can tweak the value for the `iskeyword` option (see `:h iskeyword`).

### Highlight Groups

`nvim-dap-view` defines 28 highlight groups linked to (somewhat) reasonable defaults, but they may look odd with your colorscheme. If the links aren't defined, no highlighting will be applied. To fix that, you have to manually define the highlight groups (see `:h nvim_set_hl()`). Consider contributing to your colorscheme by sending a PR to add support to `nvim-dap-view`!

<details>
    <summary>Highlight groups</summary>

| Highlight Group                      | Default link                |
|--------------------------------------|-----------------------------|
| `NvimDapViewMissingData`             | `DapBreakpoint`             |
| `NvimDapViewExceptionFilterEnabled`  | `DiagnosticOk`              |
| `NvimDapViewExceptionFilterDisabled` | `DiagnosticError`           |
| `NvimDapViewFileName`                | `qfFileName`                |
| `NvimDapViewLineNumber`              | `qfLineNr`                  |
| `NvimDapViewSeparator`               | `Comment`                   |
| `NvimDapViewThread`                  | `Tag`                       |
| `NvimDapViewThreadStopped`           | `Conditional`               |
| `NvimDapViewTab`                     | `TabLine`                   |
| `NvimDapViewTabSelected`             | `TabLineSel`                |
| `NvimDapViewControlNC`               | `Comment`                   |
| `NvimDapViewControlPlay`             | `Keyword`                   |
| `NvimDapViewControlPause`            | `Boolean`                   |
| `NvimDapViewControlStepInto`         | `Function`                  |
| `NvimDapViewControlStepOut`          | `Function`                  |
| `NvimDapViewControlStepOver`         | `Function`                  |
| `NvimDapViewControlStepBack`         | `Function`                  |
| `NvimDapViewControlRunLast`          | `Keyword`                   |
| `NvimDapViewControlTerminate`        | `DapBreakpoint`             |
| `NvimDapViewControlDisconnect`       | `DapBreakpoint`             |
| `NvimDapViewWatchExpr`               | `Identifier`                |
| `NvimDapViewWatchError`              | `DiagnosticError`           |
| `NvimDapViewWatchUpdated`            | `DiagnosticVirtualTextWarn` |
| `NvimDapViewBoolean`                 | `Boolean`                   |
| `NvimDapViewString`                  | `String`                    |
| `NvimDapViewNumber`                  | `Number`                    |
| `NvimDapViewFloat`                   | `Float`                     |
| `NvimDapViewFunction`                | `Function`                  |

</details>

### Filetypes and Autocommands

`nvim-dap-view` sets the following filetypes:

| Window                                            | Filetype      |
| ------------------------------------------------- | ------------- |
| watches, exceptions, breakpoints, scopes, threads | dap-view      |
| terminal                                          | dap-view-term |

They can be used to override buffer and window options set by `nvim-dap-view`.

If the REPL is enabled, the `dap-repl` filetype (which is set by `nvim-dap`) is also used. **If you wish to consistently override the plugin's behavior, be sure to also include the `dap-repl` filetype** in your autocommand.

<details>
    <summary>Example autocommand</summary>

Map q to quit in `nvim-dap-view` filetypes:

```lua
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
    callback = function(evt)
        vim.keymap.set("n", "q", "<C-w>q", { buffer = evt.buf })
    end,
})
```

</details>

### Custom Buttons

`nvim-dap-view` provides some default buttons for the control bar, but you can also add your own. To do that, in the `controls` table you can use the `custom_buttons` table to declare your new button and then add it at the position you want in the `buttons` list.

A custom button has 2 methods:

- `render` returning a string used to display the button (typically an emoji or a NerdFont glyph wrapped in an highlight group)
- `action` a function that will be executed when the button is clicked. The function receives 3 arguments:
    - `clicks` the number of clicks
    - `button` the button clicked (`l`, `r`, `m`)
    - `modifiers` a string with the modifiers pressed (`c` for `control`, `s` for `shift`, `a` for `alt` and `m` for `meta`)

See the `@ N` section in `:help statusline` for the complete specifications of a click handler.

<details>
    <summary>Example custom buttons</summary>

An example adding 2 buttons:

- `fun`: the most basic button possible, just prints "🎊" when clicked
- `term_restart`: an hybrid button that acts as a stop/restart button. If the stop button is triggered by anything else than a single left click (middle click, right click, double click or click with a modifier), it will disconnect the session instead.

```lua
-- No need to include the "return" statement
return {
    winbar = {
        controls = {
            enabled = true,
            buttons = { "play", "step_into", "step_over", "step_out", "term_restart", "fun" },
            custom_buttons = {
                fun = {
                    render = function()
                        return "🎉"
                    end,
                    action = function()
                        vim.print("🎊")
                    end,
                },
                -- Stop/Restart button
                -- Double click, middle click or click with a modifier disconnect instead of stop
                term_restart = {
                    render = function()
                        local session = require("dap").session()
                        local group = session and "ControlTerminate" or "ControlRunLast"
                        local icon = session and "" or ""
                        return "%#NvimDapView" .. group .. "#" .. icon .. "%*"
                    end,
                    action = function(clicks, button, modifiers)
                        local dap = require("dap")
                        local alt = clicks > 1 or button ~= "l" or modifiers:gsub(" ", "") ~= ""
                        if not dap.session() then
                            dap.run_last()
                        elseif alt then
                            dap.disconnect()
                        else
                            dap.terminate()
                        end
                    end,
                },
            },
        },
    },
}
```

</details>

## Roadmap

- Watches: rewrite. See <https://github.com/igorlfs/nvim-dap-view/issues/33>

Missing something? Create an issue with a [feature
request](https://github.com/igorlfs/nvim-dap-view/issues/new?assignees=&labels=enhancement&projects=&template=feature_request.yml&title=feature%3A+)!

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
