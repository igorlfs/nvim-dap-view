---
title: Commands
---

Commands offer the same functionality as the [API](api).

## `DapViewOpen`

Opens both `nvim-dap-view` windows[^1]: views + console.

## `DapViewClose`

Closes the views window. Accepts a bang (i.e., `DapViewClose!`) to also hide the terminal window.

## `DapViewToggle`

Behaves like `DapViewOpen` if there's no views window. Else behaves like `DapViewClose` (also accepts a bang to behave like `DapViewClose!`).

## `DapViewWatch`

In normal mode, adds the expression under the cursor to the watch list (see [caveats](faq#Why-is-DapViewWatch-not-adding-the-whole-variable-)). In visual mode, adds the selection to the watch list. Also accepts adding an expression directly (i.e., `:DapViewWatch foo + bar`), which takes precedence.

## `DapViewJump [view]`

Shows a given view and jumps to its window. For instance, to jump to the REPL, you can use `:DapViewJump repl`.

## `DapViewShow [view]`

Shows a given view. If the specified view is already the current one, jumps to its window.

## `DapViewNavigate [number]`

Switches from the current view to another one by taking the current view's index (in the winbar) and adding a count. Can optionally specify a bang to allow wrapping. Has some default [keymaps](keymaps).

[^1]: In the current tab. May close the views window in another tab.
