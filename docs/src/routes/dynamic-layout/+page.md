---
title: Dynamic Layout
category: Recipes
---

You can assign different positions and sizes to `nvim-dap-view`'s windows using functions.

## Example

When there's a single window in the current tab, you can use a _vertical_ layout to make the most of the available space. In other scenarios you fallback to a regular _horizontal_ layout:

```lua
return {
    windows = {
        -- `prev` is the last used position, might be nil
        position = function(prev)
            local wins = api.nvim_tabpage_list_wins(0)

            -- Restores previous position if terminal is visible
            if
                vim.iter(wins):find(function(win)
                    return vim.w[win].dapview_win_term
                end)
            then
                return prev
            end

            return vim.tbl_count(vim.iter(wins)
                :filter(function(win)
                    local buf = api.nvim_win_get_buf(win)
                    local valid_buftype =
                        vim.tbl_contains({ "", "help", "prompt", "quickfix", "terminal" }, vim.bo[buf].buftype)
                    local dapview_win = vim.w[win].dapview_win or vim.w[win].dapview_win_term
                    return valid_buftype and not dapview_win
                end)
                :totable()) > 1 and "below" or "right"
        end,
        size = function(pos)
            return pos == "below" and 0.25 or 0.5
        end,
        terminal = {
            -- `pos` is the position for the regular window
            position = function(pos)
                return pos == "below" and "right" or "below"
            end,
            size = 0.5,
        },
    },
}
```
