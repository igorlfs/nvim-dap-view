---
title: Automatic Toggle
category: Recipes
---

If you find yourself constantly toggling `nvim-dap-view` once a session starts, and then closing it when the session ends, you might want to add the following snippet to your configuration, to do that automatically:

```lua
local dap, dv = require("dap"), require("dap-view")
dap.listeners.before.attach["dap-view-config"] = function()
    dv.open()
end
dap.listeners.before.launch["dap-view-config"] = function()
    dv.open()
end
dap.listeners.before.event_terminated["dap-view-config"] = function()
    dv.close()
end
dap.listeners.before.event_exited["dap-view-config"] = function()
    dv.close()
end
```
