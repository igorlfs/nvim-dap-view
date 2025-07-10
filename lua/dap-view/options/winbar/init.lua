local state = require("dap-view.state")
local setup = require("dap-view.setup")
local controls = require("dap-view.options.controls")
local statusline = require("dap-view.util.statusline")
local util = require("dap-view.util")
local winbar_util = require("dap-view.options.winbar.util")
local module = ...

local M = {}

local api = vim.api

---@param bufnr? integer
M.set_winbar_action_keymaps = function(bufnr)
    if bufnr or state.bufnr then
        local winbar = setup.config.winbar

        for _, value in pairs(winbar.sections) do
            local section = winbar.custom_sections[value] or winbar.base_sections[value]

            vim.keymap.set("n", section.keymap, function()
                section.action()
            end, { buffer = bufnr or state.bufnr })
        end
    end
end

---@param idx integer
M.on_click = function(idx)
    local winbar = setup.config.winbar
    local key = winbar.sections[idx]
    local section = winbar.custom_sections[key] or winbar.base_sections[key]
    section.action()
end

---@type integer?
local labels_len
---@type integer?
local controls_len
---@type string[]?
local user_sections_labels
---@type (fun():nil)[]?
local user_buttons_renders

local set_winbar_opt = function()
    if util.is_win_valid(state.winnr) then
        local winbar_title = {}

        local winbar = setup.config.winbar
        local controls_ = winbar.controls

        if user_sections_labels == nil then
            user_sections_labels = vim.iter(winbar.sections)
                :map(function(s) ---@param s string
                    return (winbar.custom_sections[s] or winbar.base_sections[s]).label
                end)
                :totable()
        end

        if user_buttons_renders == nil then
            user_buttons_renders = vim.iter(winbar.controls.buttons)
                :map(function(b) ---@param b string
                    return (controls_.custom_buttons[b] or controls_.base_buttons[b]).render
                end)
                :totable()
        end

        ---@cast user_sections_labels string[]
        ---@cast user_buttons_renders (fun():nil)[]
        labels_len = labels_len or winbar_util.get_labels_length(user_sections_labels)
        controls_len = controls_len or winbar_util.get_controls_length(user_buttons_renders)

        local width_limit = winbar.controls.enabled and labels_len + controls_len or labels_len

        local winnr_width = api.nvim_win_get_width(state.winnr)

        if controls_.enabled and controls_.position == "left" then
            table.insert(winbar_title, controls.render() .. "%=")
        end

        for k, v in ipairs(winbar.sections) do
            local section = winbar.custom_sections[v] or winbar.base_sections[v]

            if section ~= nil then
                local is_current_section = state.current_section == v
                local label = not is_current_section and winnr_width < width_limit and section.short_label
                    or section.label
                local desc = " " .. label .. " "
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

---@param section_name dapview.Section
M.show_content = function(section_name)
    local winbar = setup.config.winbar
    local section = winbar.custom_sections[section_name] or winbar.base_sections[section_name]
    section.action()
end

---@param section_name dapview.Section
M.update_section = function(section_name)
    if setup.config.winbar.show then
        state.current_section = section_name
        set_winbar_opt()
    end
end

M.redraw_controls = function()
    if setup.config.winbar.show and setup.config.winbar.controls.enabled then
        set_winbar_opt()
    end
end

return M
