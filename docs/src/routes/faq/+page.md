---
title: FAQ
---

## Why is `nvim-dap-view` GONE when switching tabs?

`nvim-dap-view`'s defaults aim to be unintrusive: it won't be invoked if not called explicitly. Which means that, by default, it won't _reopen_ when switching tabs. If you would rather have `nvim-dap-view`'s windows "follow" the current tab, you can toggle the option `follow_tab`:

```lua
-- Your nvim-dap-view config
return {
    follow_tab = true,
}
```

## Why add `nvim-dap-view` as a dependency for `nvim-dap`?

By default, when launching a new session, `nvim-dap` creates a terminal window that takes half the screen. As a saner default, `nvim-dap-view` hijacks the terminal window, making it take only a quarter of the available space. See [this](https://github.com/rcarriga/nvim-dap-ui/issues/407) related issue (from `nvim-dap-ui`). Of course, this workaround requires `nvim-dap-view` to be loaded before any session starts (e.g., before `nvim-dap` starts), hence why it's a dependency and not the other way around.

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

## How can I see the value of an expression under cursor (hover)?

You can use `nvim-dap`'s built-in hover widget by calling `require("dap.ui.widgets").hover()`. See `:help dap-widgets` for details.

## Why is `DapViewWatch` not adding the whole variable?

In normal mode, `:DapViewWatch` expands the `<cexpr>` under the cursor (see `:help <cexpr>`). By default, this setting works really well for C-like languages, but it can be cumbersome for others. To handle that, you can tweak the value for the `'iskeyword'` option (see `:h 'iskeyword'`). For instance, with PHP, you can use `set iskeyword+=$`.

## How to control which window will be used when jumping to a breakpoint or a call in the stack?

`nvim-dap-view` ships its own `switchbuf` (see `:help 'switchbuf'`), which supports a subset of Neovim's built-in options: `newtab`, `useopen`, `usetab` and `uselast`. You can customize it with:

```lua
-- Your nvim-dap-view config
return {
    switchbuf = "useopen",
}
```

You can use commas to define fallback behavior (e.g., `"useopen,newtab"` creates a new tab if the buffer is not found). If there's no match even for the fallback behavior, `nvim-dap-view` just opens a top-level split.

## Why is `nvim-dap` overriding one of the `nvim-dap-view`'s windows when the program stops?

When `windows.terminal.position` is set to `right`, the main window may be used to display the current frame, because `nvim-dap` has its own internal `switchbuf` setting (see `:help 'switchbuf'`), which defaults to the global `switchbuf` option. A common solution is to set `nvim-dap`'s `switchbuf` to another value. For instance:

```lua
-- Don't change focus if the window is visible,
-- otherwise jump to the first window (from any tab) containing the buffer
--
-- If no window contains the buffer, create a new tab
--
-- See :help dap-defaults to learn more
require("dap").defaults.fallback.switchbuf = "usevisible,usetab,newtab"
```
