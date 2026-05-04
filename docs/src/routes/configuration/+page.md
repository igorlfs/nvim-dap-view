---
title: Configuration
---

## Setup

The default configuration below is applied when the plugin is _loaded_ (**no `setup` call required**). You can tweak the options by calling `require"dap-view".setup(opts)` or using your plugin manager's features (e.g., `lazy.nvim`'s `opts`). Your options are **deep merged** with the defaults, so you only have to override what you actually want to change.

## Defaults

These are the default options for `nvim-dap-view`.

:::note
**You don't have to copy and paste these options.** Use them as a reference.
:::

```lua
return {
    winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        -- Must be one of the sections declared above
        default_section = "watches",
        -- Append hints with keymaps within the labels
        show_keymap_hints = true,
        -- List of up to 2 strings, defining left and right separators
        separators = nil,
        -- Configure each section individually
        base_sections = {
            -- Labels can be set dynamically with functions
            -- Each function receives the window's width and the current section as arguments
            breakpoints = { label = "Breakpoints", keymap = "B" },
            scopes = { label = "Scopes", keymap = "S" },
            exceptions = { label = "Exceptions", keymap = "E" },
            watches = { label = "Watches", keymap = "W" },
            threads = { label = "Threads", keymap = "T" },
            repl = { label = "REPL", keymap = "R" },
            sessions = { label = "Sessions", keymap = "K" },
            console = { label = "Console", keymap = "C" },
        },
        -- Add your own sections
        custom_sections = {},
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
            custom_buttons = {},
        },
    },
    windows = {
        size = 0.25,
        position = "below",
        terminal = {
            size = 0.5,
            position = "left",
            -- List of debug adapters for which the terminal should be ALWAYS hidden
            hide = {},
        },
    },
    keymaps = {
        scopes = {
            toggle = { "<CR>", "<2-LeftMouse>" },
            jump_to_parent = "[[",
            set_value = "s",
        },
        watches = {
            toggle = { "<CR>", "<2-LeftMouse>" },
            jump_to_parent = "[[",
            set_value = "s",
            copy_value = "c",
            delete_expression = "d",
            append_expression = "a",
            insert_expression = "i",
            edit_expression = "e",
        },
        hover = {
            quit = "q",
            toggle = { "<CR>", "<2-LeftMouse>" },
            jump_to_parent = "[[",
            set_value = "s",
        },
        help = {
            quit = "q",
        },
        console = {
            next_session = "]s",
            prev_session = "[s",
        },
        threads = {
            toggle_subtle_frames = "t",
            filter = "f",
            invert_filter = "o",
            jump_to_frame = { "<CR>", "<2-LeftMouse>" },
            force_jump = "<C-w><CR>",
        },
        exceptions = {
            toggle_filter = { "<CR>", "<2-LeftMouse>" },
        },
        sessions = {
            switch_session = { "<CR>", "<2-LeftMouse>" },
        },
        breakpoints = {
            delete_breakpoint = "d",
            jump_to_breakpoint = { "<CR>", "<2-LeftMouse>" },
            force_jump = "<C-w><CR>",
        },
        base = {
            next_view = "]v",
            prev_view = "[v",
            jump_to_first = "[V",
            jump_to_last = "]V",
            help = "g?",
        },
    },
    icons = {
        collapsed = "󰅂 ",
        disabled = "",
        disconnect = "",
        enabled = "",
        expanded = "󰅀 ",
        filter = "󰈲",
        negate = " ",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = "",
    },
    help = {
        border = nil,
    },
    render = {
        -- Optionally a function that takes two `dap.Variable`'s as arguments
        -- and is forwarded to a `table.sort` when rendering variables in the scopes view
        sort_variables = nil,
        -- Full control of how frames are rendered, see the "Custom Formatting" page
        threads = {
            -- Choose which items to display and how
            format = function(name, lnum, path)
                return {
                    { part = name, separator = " " },
                    { part = path, hl = "FileName", separator = ":" },
                    { part = lnum, hl = "LineNumber" },
                }
            end,
            -- Align columns
            align = false,
        },
        -- Full control of how breakpoints are rendered, see the "Custom Formatting" page
        breakpoints = {
            -- Choose which items to display and how
            format = function(line, lnum, path)
                return {
                    { part = path, hl = "FileName" },
                    { part = lnum, hl = "LineNumber" },
                    { part = line, hl = true },
                }
            end,
            -- Align columns
            align = false,
        },
    },
    -- Requires neovim 0.12+
    virtual_text = {
        -- Control with `DapViewVirtualTextToggle`
        enabled = false,
        -- Supported options include "inline", "eol", and "eol_right_align"
        position = "inline",
        format = function(variable, _, _)
            return " " .. variable.value
        end,
        -- Prepend the variable name (when using eol positioning)
        prefix = function(position, node, bufnr)
            if position == "eol" or position == "eol_right_align" then
                local name = vim.treesitter.get_node_text(node, bufnr)

                return name .. " ="
            end
        end,
        -- Add commas between variables (when using eol positioning)
        suffix = function(position, _, _, var_index, num_var_line)
            if position == "eol" or position == "eol_right_align" then
                return var_index == num_var_line and "" or ","
            end
        end,
    },
    -- Controls how to jump when selecting a breakpoint or navigating the stack
    -- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
    -- Only a subset of the options is available: newtab, useopen, usetab and uselast
    -- Can also be a function that takes the current winnr and the destination bufnr
    -- If a function, should return the winnr of the destination window
    switchbuf = "usetab,uselast",
    -- Auto open when a session is started and auto close when all sessions finish
    -- Alternatively, can be a string:
    -- - "keep_terminal": as above, but keeps the terminal when the session finishes
    -- - "open_term": open the terminal when starting a new session, nothing else
    auto_toggle = false,
    -- Reopen dapview when switching to a different tab
    -- Can also be a function to dynamically choose when to follow, by returning a boolean
    -- If a function, receives the name of the adapter for the current session as an argument
    follow_tab = false,
}
```

If you would like to configure something that is not possible currently, open a [feature request](https://github.com/igorlfs/nvim-dap-view/issues/new?template=feature_request.yml).
