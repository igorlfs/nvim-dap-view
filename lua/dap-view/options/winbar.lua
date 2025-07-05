local state = require("dap-view.state")
local setup = require("dap-view.setup")
local controls = require("dap-view.options.controls")
local statusline = require("dap-view.util.statusline")
local util = require("dap-view.util")
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

local set_winbar_opt = function()
    if util.is_win_valid(state.winnr) then
        local winbar_title = {}

        local winbar = setup.config.winbar
        local controls_ = winbar.controls

        if controls_.enabled and controls_.position == "left" then
            table.insert(winbar_title, controls.render() .. "%=")
        end

        for k, v in ipairs(winbar.sections) do
            local section = winbar.custom_sections[v] or winbar.base_sections[v]

            if section ~= nil then
                local is_current_section = state.current_section == v
                local width = api.nvim_win_get_width(state.winnr)
                local labels_len = vim.iter({
                    vim.tbl_values(winbar.base_sections),
                    vim.tbl_values(winbar.custom_sections),
                })
                    :flatten()
                    :map(function(sec)
                        return vim.fn.strchars(sec.label) + 2 -- length of label including margin
                    end)
                    :fold(0, function(len_total, len_label)
                        return len_total + len_label
                    end)
                local controls_len = (#winbar.controls.buttons + #winbar.controls.custom_buttons) * 3
                local width_limit = winbar.controls.enabled and labels_len + controls_len or labels_len
                local label = not is_current_section and width < width_limit and section.short_label
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
