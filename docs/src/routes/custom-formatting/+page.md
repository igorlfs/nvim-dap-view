---
title: Custom Formatting
category: Recipes
---

You can control how the text is displayed for some views, using special `format` functions. Each customizable view has its own parameters, but the expected return type is the same: an array of `{part: string, hl?: string, separator?: string}`. The `part` is the "content" itself, `hl` is one of `nvim-dap-view`'s [highlight groups](./highlight-groups) (without the `NvimDapView` prefix) and the separator can be used to customize the divider between the current part and the next one.

The separator must be a single character. A pipe (`|`) is used if not specified.

Additionally, both `threads` and `breakpoints` support a flag for aligning their columns.

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

## Breakpoints

Besides the path (and line number) to the breakpoint, one can also manipulate the content of the line itself. It can be highlighted with treesitter by using the specifying `hl` as `true`.

### Example

```lua
return {
    render = {
        breakpoints = {
            -- The line number HATER
            format = function(line, _, path)
                return {
                    { part = path, hl = "FileName" },
                    { part = line, hl = true },
                }
            end,
            -- Alignment enjoyer
            align = true,
        },
    },
}
```
