---
title: Disassembly View
---

<img src="https://i.ibb.co/0HXpxqD/image.png" alt="disassembly view" />

The disassembly view is a [custom view](custom-views), built on top of [nvim-dap-disasm](https://codeberg.org/Jorenar/nvim-dap-disasm). To enable it, **you need to install nvim-dap-disasm**. After installing the extension, add it to your `winbar.sections` table:

```lua
return {
    winbar = {
        sections = {
            "disassembly",
            ...,
        },
    },
}
```
