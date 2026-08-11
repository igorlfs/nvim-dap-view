---
title: Dynamic Layout
category: Recipes
---

You can assign different positions and sizes to `nvim-dap-view`'s windows using functions.

## Examples

### Automatic switch between vertical and horizontal layouts

When there's a single window in the current tab, use a vertical layout to make the most of the available space. In other scenarios, fallback to a regular horizontal layout:

```lua
return {
    windows = {
        -- `prev` is the last used position, might be nil
        position = function(prev)
            local wins = vim.api.nvim_tabpage_list_wins(0)

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
                    local buf = vim.api.nvim_win_get_buf(win)
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

### Manual switch between vertical and horizontal layouts

If you'd rather be more explicit about when each layout is used, you can use multiple keybindings:

```lua
-- Assign one keymap to
local horizontal_layout = function()
    if not vim.g._dv_below then
        require("dap-view").close(true)
    end
    vim.g._dv_below = true
    require("dap-view").toggle()
end

-- And the other one to
local vertical_layout = function()
    if vim.g._dv_below then
        require("dap-view").close(true)
    end
    vim.g._dv_below = nil
    require("dap-view").toggle()
end

-- your nvim-dap-view config
return {
    windows = {
        position = function()
            return vim.g._dv_below and "below" or "right"
        end,
    }
}
```

### Keep manual resizes

`nvim-dap-view` always attempts to respect the predefined size. If you'd rather have if follow manual resizes, use the following:

```lua
local api = vim.api

api.nvim_create_autocmd("WinResized", {
    callback = function()
        local win = require("dap-view.state").winnr

        if not win then
            return
        end

        local cfg = require("dap-view.setup").config

        local pos_ = cfg.windows.position
        local pos = type(pos_) == "function" and pos_() or pos_

        vim.g._dv_size = pos == "below" and api.nvim_win_get_height(win) or api.nvim_win_get_width(win)
    end,
})

return {
    -- your nvim-dap-view config
    windows = {
        size = function()
            return vim.g._dv_size or 0.4 -- a reasonable default
        end,
    },
}
```

Tip: you can both these approaches. Check [this comment](https://github.com/igorlfs/nvim-dap-view/issues/203#issuecomment-5235248001)
