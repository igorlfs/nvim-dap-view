---
title: API
---

The API offers the same functionality as the [commands](commands).

## Open

```lua
require("dap-view").open()
```

Opens both `nvim-dap-view` windows[^1]: views + console.

## Close

```lua
---@param hide_terminal? boolean
require("dap-view").close()
```

Closes the views window. Can also hide the terminal window if specified.

## Toggle

```lua
---@param hide_terminal? boolean
require("dap-view").toggle()
```

Calls `require("dap-view").open()` if there's no views window. Else, behaves like `require("dap-view").close()`

## Add Expr

```lua
---@param expr? string
require("dap-view").add_expr(expr)
```

In normal mode, adds the expression under the cursor to the watch list (see [caveats](faq#dapviewwatch-isnt-adding-the-whole-variable)). In visual mode, adds the selection to the watch list. If `expr` is specified, adds the expression directly, overriding previous conditions.

## Jump To View

```lua
---@param view "breakpoints" | "exceptions" | "watches" | "repl" | "threads" | "console" | "scopes" | "sessions" | string
require("dap-view").jump_to_view(view)
```

Shows a given view and jumps to its window.

## Show View

```lua
---@param view "breakpoints" | "exceptions" | "watches" | "repl" | "threads" | "console" | "scopes" | "sessions" | string
require("dap-view").show_view(view)
```

Shows a given view. If the specified view is already the current one, jumps to its window.

[^1]: In the current tab. May close the views window in another tab.
