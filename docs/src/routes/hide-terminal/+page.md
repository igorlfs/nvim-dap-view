---
title: Hide Terminal
---

Some debug adapters don't use the integrated terminal (aka "console"). To avoid having a completely useless window lying around, you can hide the terminal for them. To achieve that, add the following snippet to your `nvim-dap-view` setup:

```lua
return {
    windows = {
        terminal = {
            -- Use the actual names for the adapters you want to hide
            hide = { "go" }, -- `go` is known to not use the terminal.
        },
    },
}
```

## Anchoring

In some scenarios, it's useful to use another window as if it was `nvim-dap-view`'s terminal.

One such scenario is when using the `delve` adapter for Go (more specifically, when using an `attach` request): the window with the terminal that launched `dlv` can act as if it was the `nvim-dap-view`'s terminal window. By doing that, `nvim-dap-view`'s main window will "follow" `delve`'s window. Watch this [video](https://github.com/user-attachments/assets/5dce4b3d-fc01-4be6-9a72-b0f969e34b14) to see what it looks like.

To achieve that, in addition to hidding the terminal for `delve` (see above), you have to create your own `anchor` function that returns a window number (or `nil`), which is used to mark the anchor window. If `nil` is returned, there's a fallback to the default behavior. Here's a simple function you can use:

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
