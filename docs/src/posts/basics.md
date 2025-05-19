---
title: Basics
hidden: true
---

Getting started with `nvim-dap` is easier than it sounds! This guide aims to explain all you need to know.

First things first: what is the DAP? Much like the LSP, the DAP is a protocol created to solve a scalability problem: it used to be the case that each text editor had to have a custom integration for each debugger they wanted to support. That means handling the communication was a nightmare: each debugger has its own way of defining breakpoints, or evaluating expressions and whatnot. What DAP brings to the table is a standardization for this communication, massively simplifying the implementation.

To accomplish its goal, the DAP introduces the concept of **debug adapters**: programs that make debuggers comply with the protocol (in fact, many debuggers actually support the protocol natively, such as `gdb`). The first step (after installing the plugin) to setup `nvim-dap` is choosing an adapter, which will depend on the language you're using. You can install an adapter with your system's package manager (or, most likely, using [mason.nvim](https://github.com/mason-org/mason.nvim)). To give some concrete examples, this guides picks `codelldb`: [a powerful adapter](https://github.com/vadimcn/codelldb) which can be used for C, C++ and Rust. Under the hood, `codelldb` (the adapter) uses `lldb` (the debugger). To configure `codelldb` (or any adapter, for that matter) refer to `nvim-dap`'s [wiki](https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation). There, we can find a [snippet](https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)#1-11-0-and-later) to define `codelldb`:

```lua
require("dap").adapters.codelldb = {
    type = "executable",
    command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

    -- On windows you may have to uncomment this:
    -- detached = false,
}
```

Fantastic! Now we have to define a way for the adapter to actually connect with the code we're trying to debug. That's what's known as a "configuration". `nvim-dap` offers it's own way of defining configurations, but my recommendation is to use a `.vscode/launch.json` file, which `nvim-dap` supports natively, out of the box. The main advantage of this approach is that your colleagues will be able to use the configuration as well!

The configuration, however, can be a bit tricky. There are some base options, but most adapters introduce their own flags. Again, you can use the `nvim-dap` [wiki](https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation) as reference, but you may need to also check your adapter's documentation as well. Here's a basic configuration to launch a C++ program using `codelldb`:

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
        }
    ]
}
```

Great! The tricky part is over! Now all you have to do is configure `nvim-dap` like any other plugin: get to know the commands and define some keybindings (take a look at [my config](https://github.com/igorlfs/dotfiles/blob/main/nvim/.config/nvim/lua/plugins/bare/nvim-dap.lua) if you need inspiration). Refer to `:h dap-user-commands` to learn what you can do.

The last step is to test your setup. Remember to compile your program with debug symbols if necessary[^1]. Create a breakpoint with `:DapToggleBreakpoint` (or using your custom keymap) and then start a debugging session with `:DapContinue`. If all goes well, the execution will be stopped when hitting the line with the breakpoint.

Hooray! Now you can start tweaking `nvim-dap-view`! 🎉

[^1]: The path of the binary with debug symbols must match the path of the `program` defined in the configuration.
