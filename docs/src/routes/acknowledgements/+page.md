---
title: Acknowledgements
---

## Special Thanks To

- [Mathias Fußenegger](https://github.com/mfussenegger) (mfussenegger), the **truest** Neovim GOAT, for developing [nvim-dap](https://github.com/mfussenegger/nvim-dap) :goat:

### Contributors

- [noirbizarre](https://github.com/noirbizarre) for the initial [control bar](/control-bar) implementation
- [tomtomjhj](https://github.com/tomtomjhj) for multiple buffer life-cycle improvements

And [everyone else](https://github.com/igorlfs/nvim-dap-view/graphs/contributors) who contributed so far! :heart:

### Sponsors

You can make your nickname show up here by making a small, one-time, [donation](https://github.com/sponsors/igorlfs)

## Inspirations

- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) is obviously a huge inspiration. Numerous implementation details were made much easier with access to its code.
- [nvim-dap-exception-breakpoints](https://github.com/lucaSartore/nvim-dap-exception-breakpoints), for the handling of exception breakpoints as a separate "view".
- [Kulala](https://github.com/mistweaverco/kulala.nvim) for the creative usage of Neovim's `'winbar'` to handle multiple "views". Great plugin, by the way!
- Believe it or not, but [Zed](https://zed.dev/)'s debugger was also a huge source of inspiration!

## Code Snippets

- The type validation for the configuration is based on [blink.cmp](https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/config/utils.lua)'s, which itself is partially taken from a PR to [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim/pull/934/files#diff-09ebcaa8c75cd1e92d25640e377ab261cfecaf8351c9689173fd36c2d0c23d94R16).
- Code to inject treesitter highlights into line is taken from [quicker.nvim](https://github.com/stevearc/quicker.nvim).
- Code to copy extmarks from a buffer to a line is taken from [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context).
