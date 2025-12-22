---
title: Custom Views
category: Recipes
---

You can write your own views. If you are a plugin author, this allows you to embed your plugin into `nvim-dap-view`.

If you are a regular user and you are missing a view, consider making a [feature request](https://github.com/igorlfs/nvim-dap-view/issues/new?template=feature_request.yml) instead of writing your own implementation.

Writing a custom view is similar to writing a [custom button](control-bar#Custom-Buttons). A view consists of an ID and 5 fields:

1. A `label`, the string that will show up in the user's winbar
2. A `short_label`, which is used when there's not enough space to display the whole winbar
3. An `action` function to render the component
4. A `keymap`, which will trigger the action
5. A `buffer` function that will create a new buffer and return its `bufnr`

The logic after the action is triggered is **not** handled by `nvim-dap-view`.

## Example

A bare bones view would consist of:

```lua
return {
    winbar = {
        custom_sections = {
            my_new_view = { -- the ID
                label = "My new view",
                short_label = "mnv",
                action = function()
                    vim.print("Hi from view")
                end,
                keymap = "M",
                buffer = function()
                    return vim.api.nvim_create_buf(true, false)
                end,
            },
        },
    },
}
```

To add a custom view to your config, just add it to the sections table as if it was a regular view:

```lua
return {
    winbar = {
        sections = {
            "my_new_view",
            -- ...
        },
    },
}
```

### Register View

If you are a plugin author, you can use the `register_view` function to ensure your view is loaded. By doing that, users don't have to create the custom view "manually". An example can be found [here](https://codeberg.org/Jorenar/nvim-dap-disasm/src/commit/fb2dc2c5fb19cac8bc642f0c411d57cc14e99cc0/lua/dap-disasm.lua#L378-L385).
