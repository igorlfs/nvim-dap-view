---
title: Filetypes & Autocmds
---

`nvim-dap-view` sets the following filetypes:

| Buffer                                                      | Filetype       |
| ----------------------------------------------------------- | -------------- |
| Breakpoints, Exceptions, Sessions, Scopes, Threads, Watches | dap-view       |
| Terminal                                                    | dap-view-term  |
| Hover                                                       | dap-view-hover |
| Help                                                        | dap-view-help  |

They can be used to override buffer and window options set by `nvim-dap-view`.

If the REPL is enabled, the `dap-repl` filetype (which is set by `nvim-dap`) is also used. **If you wish to consistently override the plugin's behavior, be sure to also include the `dap-repl` filetype** in your autocmd. If you also have a [custom view](custom-views) enabled, ensure its filetype is also added to your autocmd.
