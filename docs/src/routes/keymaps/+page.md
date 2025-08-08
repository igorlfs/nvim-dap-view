---
title: Keymaps
---

Each view has its own keymaps, listed below. At any time (from within `nvim-dap-view`'s main window) you can use `g?` to show a "help" window that lists all of them.

The help window itself has only 1 mapping: it can be closed with `q`.

| Key    | Action                                       |
| ------ | -------------------------------------------- |
| **Threads**                                           |
| `<CR>` | Jump to a frame                              |
|    `t` | Toggle subtle frames                         |
|    `f` | Filter frames (via Lua patterns)             |
|    `o` | Omit results matching filter (invert filter) |
| **Scopes**                                            |
| `<CR>` | Expand or collapse a variable                |
|    `o` | Trigger actions                              |
| **Breakpoints**                                       |
| `<CR>` | Jump to a breakpoint                         |
|    `d` | Delete a breakpoint                          |
| **Watches**                                           |
| `<CR>` | Expand or collapse a variable                |
|    `i` | Insert an expression                         |
|    `d` | Delete an expression                         |
|    `e` | Edit an expression                           |
|    `c` | Copy the value of an expression or variable  |
|    `s` | Set the value of an expression or variable   |
| **Exceptions**                                        |
| `<CR>` | Toggle filter                                |
| **Sessions**                                          |
| `<CR>` | Switch to a session                          |
| **Help**                                              |
|    `q` | Close                                        |

`nvim-dap-view` doesn't define any keybindings outside its own buffers: you have to create your own bindings to call `open`, `close` or `toggle` and other API [functions](api) (or [commands](commands)).
