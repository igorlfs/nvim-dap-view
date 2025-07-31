---
title: Disassembly View
---

<img src="https://github.com/user-attachments/assets/97ed9e8c-20a0-4355-bb00-5199c7b3cd59" alt="disassembly view" />

The disassembly view is a [custom view](custom-views), built on top of [nvim-dap-disasm](https://github.com/Jorenar/nvim-dap-disasm). To enable it, **you need to install nvim-dap-disasm**. After installing the extension, all you have to do is adding it to your sections table:

```lua
return {
    sections = {
        -- ...
        "disassembly",
    },
}
```

:::note
If using `lazy.nvim`, make sure to add `nvim-dap-view` as a dependency for `nvim-dap-disasm`and **NOT** the other way around. That's necessary for `nvim-dap-disasm` to recognize `nvim-dap-view`'s installation. A sample spec would be:
:::

```lua
return {
    {
        "Jorenar/nvim-dap-disasm",
        dependencies = "igorlfs/nvim-dap-view",
        config = true,
    },
}
```
