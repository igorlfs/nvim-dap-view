---
title: Advanced 'switchbuf'
category: Recipes
---

You can tune the behavior of nvim-dap-view's jump to breakpoint and frame features, by using nvim-dap-view's own `switchbuf` config option. Similarly to the built-in option, you can combine different behaviors with a comma separated list. Available options include:

- `newtab`: always creates a new tab
- `useopen`: tries to find the buffer to jump to _only_ in the current tab
- `usetab`: like `useopen`, but searches _every_ tab (**default**)
- `uselast`: jump to the previously used window, if eligible

For instance, with `useopen,newtab`, if the buffer is not found in the current tab, a new tab is created.

For more advanced use cases, you can write your own `switchbuf` function. It receives 2 arguments: the _current_ window number and the buffer number _to jump to_. It should (optionally) return a window number for the jump's destination window.

If a combination of options does not yield a valid window number for the destination (e.g., `useopen` but the buffer is hidden), there's a fallback to create a top-level split.

## Force Behavior

Sometimes, having a custom `switchbuf` is not enough. In these scenarios, you can override your own setting by using `<C-w><CR>` to bring a list with all available options, affecting only the current jump.
