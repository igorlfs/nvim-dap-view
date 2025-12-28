---
title: Restoring Sessions
category: Recipes
---

Vim offers a powerful way of restoring the state of the editor: sessions (see `:h Session`). Sessions are native, but they can be greatly enhanced by plugins: some "session managers" bring a seamless experience to what would otherwise be a rather manual setup.

:::info
Whenever this page refers to a "session", it is referring to a _vim session_, except when explicitly stated.
:::

`nvim-dap-view` hooks into this session system to restore its internal state. Currently, the following data is restored:

- The selected "view" (section)
- The full state of **watched expressions**, including expansions of variables

In addition to that, you can also restore **breakpoints**, by leveraging [`persistent-breakpoints.nvim`](https://github.com/Weissle/persistent-breakpoints.nvim). Alternatively, some "session managers" support this feature out of the box (such as [`possession.nvim`](https://github.com/jedrzejboczar/possession.nvim)).

Other data, such as the active **DAP** sessions and their stack traces are considered "ephemeral" and are **not restored**.

## Setup

If you're using a "session manager" plugin, check if it uses _vim sessions_ as its backbone (i.e., it does not rely on its own implementation). Custom session implementations may not work, or may require additional configuration.

To let `nvim-dap-view` restore its state, ensure the following criteria are met:

- `'sessionoptions'` includes `"global"`
- `nvim-dap-view` is **NOT** being lazy loaded

The plugin lazy loads itself. By manually lazy loading, you may prevent the "session restoration" hook from triggering.
