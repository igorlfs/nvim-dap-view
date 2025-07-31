---
title: Control Bar
---

The control bar can be used to control a session with clickable "buttons".

It is disabled by default. It can be enabled by setting `winbar.controls.enable`.

<img src="https://i.ibb.co/wNbqBnyN/image.png" alt="control bar">

You can find the default configuration on the [config](configuration) page.

## Custom Buttons

`nvim-dap-view` provides some default buttons for the control bar, but you can also add your own. To do that, you can use the `controls.custom_buttons` table to declare your new button and then add it at the position you want in the `buttons` list.

A custom button has 2 methods:

1. `render`, returning a string used to display the button (typically an emoji or a NerdFont glyph wrapped in an highlight group)
2. `action`, a function that will be executed when the button is clicked. The function receives 3 arguments:
    - `clicks` the number of clicks
    - `button` the button clicked (`l`, `r`, `m`)
    - `modifiers` a string with the modifiers pressed (`c` for `control`, `s` for `shift`, `a` for `alt` and `m` for `meta`)

See the `@ N` section in `:help statusline` for the complete specifications of a click handler.

### Example

An example adding 2 buttons:

- `fun`: the most basic button possible, just prints "🎊" when clicked
- `term_restart`: an hybrid button that acts as a stop/restart button. If the stop button is triggered by anything else than a single left click (middle click, right click, double click or click with a modifier), it will disconnect the session instead.

```lua
return {
    winbar = {
        controls = {
            enabled = true,
            buttons = { "play", "step_into", "step_over", "step_out", "term_restart", "fun" },
            custom_buttons = {
                fun = {
                    render = function()
                        return "🎉"
                    end,
                    action = function()
                        vim.print("🎊")
                    end,
                },
                -- Stop/Restart button
                -- Double click, middle click or click with a modifier disconnect instead of stop
                term_restart = {
                    render = function()
                        local session = require("dap").session()
                        local group = session and "ControlTerminate" or "ControlRunLast"
                        local icon = session and "" or ""
                        return "%#NvimDapView" .. group .. "#" .. icon .. "%*"
                    end,
                    action = function(clicks, button, modifiers)
                        local dap = require("dap")
                        local alt = clicks > 1 or button ~= "l" or modifiers:gsub(" ", "") ~= ""
                        if not dap.session() then
                            dap.run_last()
                        elseif alt then
                            dap.disconnect()
                        else
                            dap.terminate()
                        end
                    end,
                },
            },
        },
    },
}
```
