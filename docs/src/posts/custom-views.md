---
title: Custom Views
category: Recipes
---

You can write your own views. If you are a plugin author, this allows you to embed your plugin into `nvim-dap-view`.

If you are a regular user and you are missing a view, consider making a [feature request](https://github.com/igorlfs/nvim-dap-view/issues/new?template=feature_request.yml) instead of writing your own implementation.

Writing a custom view is similar to writing a [custom button](control-bar#custom-buttons). A view consists of 3 fields:

1. A `label`, the string that will show up in the user's winbar
2. A `keymap`, which will trigger the action
3. An `action`, a function to render the component

The logic after the action is triggered is **not** handled by `nvim-dap-view`.

## Example

The most basic view you could write would be as follows

```lua
return {
    winbar = {
        sections = {
            "my_new_view",
            -- some other views...
            "breakpoints",
            -- ...
        },
        default_section = "my_new_view",
        custom_sections = {
            my_new_view = {
                label = "Foo",
                keymap = "F",
                action = function()
                    -- Updates the winbar
                    require("dap-view.options.winbar").update_section("my_new_view")

                    -- The action itself
                    vim.print("Hi from Foo")
                end,
            },
        },
    },
}
```
