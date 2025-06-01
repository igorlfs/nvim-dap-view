---
title: API
---

The API offer the same functionality as the [commands](commands).

```lua
require("dap-view").open()
```

Opens both `nvim-dap-view` windows[^1]: views + console.

---

```lua
---@param hide_terminal? boolean
require("dap-view").close()
```

Closes the views window. Can also hide the terminal window if specified.

---

```lua
---@param hide_terminal? boolean
require("dap-view").toggle()
```

Calls `require("dap-view").open()` if there's no views window. Else, behaves like `require("dap-view").close()`

---

```lua
---@param expr? string
require("dap-view").add_expr()
```

In normal mode, adds the expression under the cursor to the watch list (see [caveats](faq#dapviewwatch-isnt-adding-the-whole-variable)). In visual mode, adds the selection to the watch list. If `expr` is specified, adds the expression directly.

---

```lua
---@param view "breakpoints" | "exceptions" | "watches" | "repl" | "threads" | "console" | "scopes"
require("dap-view").jump_to_view(view)
```

Shows a given view and jumps to its window.

---

```lua
---@param view "breakpoints" | "exceptions" | "watches" | "repl" | "threads" | "console" | "scopes"
require("dap-view").show_view(view)
```

Shows a given view. If the specified view is already the current one, jumps to its window.

[^1]: In the current tab. May close the views window in another tab.
