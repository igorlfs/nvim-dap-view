---
title: Filetypes & Autocommands
---

`nvim-dap-view` sets the following filetypes:

| Buffer                                            | Filetype      |
| ------------------------------------------------- | ------------- |
| Breakpoints, Exceptions, Scopes, Threads, Watches | dap-view      |
| Terminal                                          | dap-view-term |
| Help                                              | dap-view-help |

They can be used to override buffer and window options set by `nvim-dap-view`.

If the REPL is enabled, the `dap-repl` filetype (which is set by `nvim-dap`) is also used. **If you wish to consistently override the plugin's behavior, be sure to also include the `dap-repl` filetype** in your autocommand.

## Example autocommand

Map q to quit in `nvim-dap-view` filetypes:

```lua
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
    callback = function(evt)
        vim.keymap.set("n", "q", "<C-w>q", { buffer = evt.buf })
    end,
})
```
