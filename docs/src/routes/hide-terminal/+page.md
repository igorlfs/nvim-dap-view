---
title: Hide Terminal
---

Some debug adapters don't use the integrated terminal (aka "console"). To avoid having a completely useless window lying around, you can hide the terminal by adding the following snippet to your `nvim-dap-view` setup:

```lua
return {
    windows = {
        terminal = {
            -- Use the actual names for the adapters you want to hide
            hide = { "delve" }, -- `delve` is known to not use the terminal.
        },
    },
}
```

## Anchoring

In some scenarios, it's useful to use another window as if it was `nvim-dap-view`'s terminal. By doing that, `nvim-dap-view`'s main window will "follow" another window. Watch this [video](https://github.com/user-attachments/assets/5dce4b3d-fc01-4be6-9a72-b0f969e34b14) to see what this looks like.

One such scenario is when using the `delve` adapter for Go (more specifically, when using an `attach` request): the window with the terminal that launched `dlv` can act as if it was `nvim-dap-view`'s terminal window. In the context of `delve`, that's useful, because the `dlv` process will behave as if it was the terminal (receiving input, displaying output, etc).

To achieve that, in addition to hiding the terminal for `delve` (see above), you have to create your own `anchor` function that returns a window number (or `nil`), which is used to mark the anchor window. If `nil` is returned, there's a fallback to the default behavior. Here's a simple function you can use:

```lua
return {
    windows = {
        anchor = function()
            -- Anchor to the first terminal window found in the current tab
            -- Tweak according to your needs
            local windows = vim.api.nvim_tabpage_list_wins(0)

            for _, win in ipairs(windows) do
                local bufnr = vim.api.nvim_win_get_buf(win)
                if vim.bo[bufnr].buftype == "terminal" then
                    return win
                end
            end
        end,
    },
}
```
