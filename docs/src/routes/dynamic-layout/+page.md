---
title: Dynamic Layout
category: Recipes
---

You can assign different positions to `nvim-dap-view`'s windows using functions.

## Example

When there's a single window in the current tab, you can use a _vertical_ layout to make the most of the available space. In other scenarios you fallback to a regular _horizontal_ layout:

```lua
return {
    windows = {
        position = function()
            return vim.tbl_count(vim.iter(vim.api.nvim_tabpage_list_wins(0))
                :filter(function(win)
                    local buf = vim.api.nvim_win_get_buf(win)
                    -- extui has some funky windows
                    return vim.bo[buf].buftype == ""
                end)
                :totable()) > 1 and "below" or "right"
        end,
        terminal = {
            -- `pos` is the position for the regular window
            position = function(pos)
                return pos == "below" and "right" or "below"
            end,
        },
    },
}
```
