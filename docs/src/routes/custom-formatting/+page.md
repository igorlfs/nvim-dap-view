---
title: Custom Formatting
category: Recipes
---

You can control how the text is displayed for some views, using special `format` functions. Each customizable view has its own parameters, but the expected return type is the same: an array of `{part: string, hl?: string}`. The `part` is the "content" itself, and `hl` is one of `nvim-dap-view`'s [highlight groups](./highlight-groups) (without the `NvimDapView` prefix).

## Threads

You can manipulate the frame _name_ (usually the function name), its line number and path.

### Examples

#### Display just the file name, instead of relative path

```lua
return {
    render = {
        threads = {
            format = function(name, lnum, path)
                return {
                    { part = name, separator = " " },
                    -- See :h filename-modifiers
                    { part = vim.fn.fnamemodify(buf_name, ":t"), hl = "FileName", separator = ":" },
                    { part = lnum, hl = "LineNumber" },
                }
            end,
        },
    },
}
```

#### Restore pre v1.0.0 behavior

```lua
return {
    render = {
        threads = {
            format = function(name, lnum, path)
                return {
                    { part = path, hl = "FileName" },
                    { part = lnum, hl = "LineNumber" },
                    { part = name },
                }
            end,
        },
    },
}
```
