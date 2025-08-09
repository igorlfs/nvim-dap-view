---
title: Basics
---

Getting started with `nvim-dap` is easier than it sounds! This guide aims to explain all you need to know.

## What is the Debug Adapter Protocol?

First things first: what is the DAP? Much like the LSP, the DAP is a protocol created to solve a scalability problem: it used to be the case that each text editor had to have a custom integration for each debugger they wanted to support.

That means handling the communication was a nightmare: each debugger has its own way of defining breakpoints, or evaluating expressions and whatnot. What DAP brings to the table is a **standardization for this communication**, massively simplifying the implementation.

To accomplish its goal, the DAP introduces the concept of **debug adapters**: programs that make _debuggers_ comply with the protocol's communication standards. It's important to have this distinction clear: a _debugger_ and a debug adapter are _distinct programs_. All throughout `nvim-dap-view`'s you'll the see the term _adapter_, referring to a _debug adapter_, but there are only a couple or so mentions of _debuggers_, since the protocol is about _adapters_.

To make matters a little more confusing, some debuggers implement the protocol natively, meaning that they do not rely on an external adapter. One such example is `gdb`: from version 14.0 onwards, it ships with a flag that allows communication via DAP. Previously, to use the `gdb` debugger via DAP, you'd have to install a custom adapter, such as the one [bundled](https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)) with the VS Code C++ extension.

## Basic Configuration

To get started with the configuration, you first have to install `nvim-dap`, similarly to how you install other plugins. If you're not familiar with the installation of plugins, you can take a peek at [quickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) to get basics of configuring Neovim.

The DAP configuration is essentially two fold: you first _define_ an adapter and then set a _configuration_ to interact with the program you're trying to debug. _Defining_ an adapter tells `nvim-dap` how to interact with the adapter (and therefore has nothing to do with your code). You'll **define the adapter only once**, but you may have multiple _configurations_ for an adapter, depending on your needs.

Most languages have, at most, a single adapter, so there's not a lot of decision here. You can install an adapter with your system's package manager or using [mason.nvim](https://github.com/mason-org/mason.nvim).

To give a concrete example, this guides uses [codelldb](https://github.com/vadimcn/codelldb): a powerful adapter which can be used for C, C++ and Rust[^1]. Under the hood, `codelldb` (the adapter) uses `lldb` (the debugger). To **define** `codelldb` (or any adapter, for that matter) refer to `nvim-dap`'s [wiki](https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation). There, we can find the following [snippet](https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)#1-11-0-and-later):

```lua
require("dap").adapters.codelldb = {
    type = "executable",
    command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

    -- On windows you may have to uncomment this:
    -- detached = false,
}
```

Fantastic! Now we have to define a way for the adapter to actually connect with the code we're trying to debug. Which also known as the "configuration". The naming here unfortunately sucks, since... You have to _configure_ everything, including that aren't the "configuration". But I digress.

`nvim-dap` offers it's own way of defining configurations, but my recommendation is to use a `.vscode/launch.json` file, which `nvim-dap` supports natively, out of the box. The main advantage of this approach is that your colleagues will be able to use the configuration as well! What you may consider a disadvantage here is the fact that you'd have copy and paste the same file in multiple locations.

The configuration itself can be a bit tricky. There are some base options, but most adapters introduce their own flags. Again, you can use the `nvim-dap`'s [wiki](https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation) as a reference, but you may need to also check your adapter's documentation as well. Here's a basic `.vscode/launch.json` to **launch** a C++ program using `codelldb`:

```jsonc
{
    "version": "0.2.0",
    "configurations": [
        {
            // Base options
            "name": "Launch My Cool Project",   // Actually not that important, could be anything
            "type": "codelldb",                 // Must match the adapter we defined earlier
            "request": "launch",                // Could be either launch or attach

            // Adapter specific options
            "program": "${workspaceFolder}/path/to/your/binary" // Path for the program that will be launched
            // In spite of not being a base option, "program" is fairly common for launch requests
            // '${workspaceFolder}' is a VSCode like variable that nvim-dap automatically resolves
        }
    ]
}
```

Great! The tricky part is over! Now all you have to do is configure `nvim-dap` like any other plugin[^2]: get to know the commands and define some keybindings (take a look at [my config](https://github.com/igorlfs/dotfiles/blob/main/nvim/.config/nvim/lua/plugins/bare/nvim-dap.lua) if you need inspiration). I recommend using the `<FX>` keys to create the bindings. Refer to `:h dap-user-commands` to learn what you can do. A bare bones setup would include at least a mapping to `:DapToggleBreakpoint` and `:DapContinue`.

The last step is to test your setup. Remember to compile your program with debug symbols if necessary. To start a basic session, **add a breakpoint**. It's important to define a breakpoint beforehand, to not have the program finish executing before you're able to add one. You can then `:DapContinue` (or your own mapping) to create the session. If all goes well, the execution will be stopped when hitting the line with the breakpoint.

Hooray! Now you can start tweaking `nvim-dap-view`! 🎉

[^1]: And other low level languages. Do notice that there isn't a 1:1 mapping between adapters and neovim's filetypes.
[^2]: It's worth noting that `nvim-dap` does adhere to the `setup` function "convention".
