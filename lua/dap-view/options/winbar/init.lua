local state = require("dap-view.state")
local setup = require("dap-view.setup")
local controls = require("dap-view.options.controls")
local statusline = require("dap-view.util.statusline")
local util = require("dap-view.util")
local module = ...

local M = {}

local api = vim.api
local log = vim.log.levels

---@type table<string,integer>
local custom_bufnrs = {}

---Creates a buffer for a custom action, assigns keymaps, set it as the selected view and refresh the winbar
---@param view dapview.CustomSection
local custom_action_wrapper = function(view)
    local section = setup.config.winbar.custom_sections[view]

    local bufnr = nil
    if custom_bufnrs[view] == nil or not util.is_buf_valid(custom_bufnrs[view]) then
        bufnr = section.buffer()
        if util.is_buf_valid(bufnr) then
            custom_bufnrs[view] = bufnr
        else
            vim.notify("Couldn't set the buffer for " .. view .. " view", log.ERROR)
        end
    end

    if custom_bufnrs[view] then
        M.set_action_keymaps(custom_bufnrs[view])

        api.nvim_win_call(state.winnr, function()
            vim.wo[state.winnr][0].winfixbuf = false
            api.nvim_set_current_buf(custom_bufnrs[view])
            vim.wo[state.winnr][0].winfixbuf = true
        end)
    end

    M.refresh_winbar(view)
end

---@param view dapview.Section
---@param action fun(): nil
local wrapped_action = function(view, action)
    if not util.is_win_valid(state.winnr) then
        return
    end
    if setup.config.winbar.custom_sections[view] ~= nil then
        ---@cast view dapview.CustomSection
        custom_action_wrapper(view)
        action()
    else
        if view == "repl" then
            require("dap-view.repl").show()
        else
            coroutine.wrap(function()
                require("dap-view.views").switch_to_view(view)
            end)()
        end
    end
end

---@param bufnr? integer
M.set_action_keymaps = function(bufnr)
    if bufnr or state.bufnr then
        local winbar = setup.config.winbar

        for k, view in pairs(winbar.sections) do
            local section = winbar.custom_sections[view] or winbar.base_sections[view]

            if not section then
                vim.notify_once("View '" .. view .. "' not found, skipping setup", log.WARN)
                winbar.sections[k] = nil
            else
                vim.keymap.set("n", section.keymap, function()
                    wrapped_action(view, section.action)
                end, { buffer = bufnr or state.bufnr })
            end
        end
    end
end

---@param idx integer
M.on_click = function(idx)
    local winbar = setup.config.winbar
    local view = winbar.sections[idx]
    local section = winbar.custom_sections[view] or winbar.base_sections[view]
    wrapped_action(view, section.action)
end

M.set_winbar_opt = function()
    if util.is_win_valid(state.winnr) then
        local winbar_title = {}

        local winbar = setup.config.winbar
        local controls_ = winbar.controls

        if controls_.enabled and controls_.position == "left" then
            table.insert(winbar_title, controls.render() .. "%=")
        end

        local win_width = api.nvim_win_get_width(state.winnr)

        for k, v in ipairs(winbar.sections) do
            local section = winbar.custom_sections[v] or winbar.base_sections[v]

            if section ~= nil then
                local label = type(section.label) == "function" and section.label(win_width, state.current_section)
                    or section.label

                ---@cast label string

                local desc = " " .. label .. " "
                if winbar.show_keymap_hints then
                    desc = desc .. "[" .. section.keymap .. "]" .. " "
                end
                desc = statusline.clickable(desc, module, "on_click", k)

                if state.current_section == v then
                    desc = statusline.hl(desc, "TabSelected")
                else
                    desc = statusline.hl(desc, "Tab")
                end

                table.insert(winbar_title, desc)
            end
        end

        if controls_.enabled and controls_.position == "right" then
            table.insert(winbar_title, "%=" .. controls.render())
        end

        local value = table.concat(winbar_title, "")

        vim.wo[state.winnr][0].winbar = value
    end
end

---@param view dapview.Section
M.show_content = function(view)
    local winbar = setup.config.winbar
    local section = winbar.custom_sections[view] or winbar.base_sections[view]
    wrapped_action(view, section.action)
end

---@param new_view? dapview.Section
M.refresh_winbar = function(new_view)
    if setup.config.winbar.show then
        if new_view then
            state.current_section = new_view
        end
        M.set_winbar_opt()
    end
end

M.redraw_controls = function()
    if setup.config.winbar.show and setup.config.winbar.controls.enabled then
        M.set_winbar_opt()
    end
end

return M
