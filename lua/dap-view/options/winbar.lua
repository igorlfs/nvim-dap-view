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

local labels_len
local controls_len

local set_winbar_opt = function()
    ---@param len_total integer
    ---@param len_label integer
    ---@return integer
    local function ret_total_length(len_total, len_label)
        return len_total + len_label
    end

    ---@param base table
    ---@param custom table
    ---@return integer
    local function ret_labels_length(base, custom)
        return vim.iter({ base, custom })
            :flatten()
            :map(
                ---@param sec table
                ---@return integer
                function(sec)
                    return vim.fn.strdisplaywidth(sec.label) + 2 -- length of label including margin
                end
            )
            :fold(0, ret_total_length)
    end

    ---@param buttons string[]
    ---@param base_icons table
    ---@param custom_buttons table
    ---@return integer
    local function ret_controls_length(buttons, base_icons, custom_buttons)
        return vim.iter(buttons)
            :map(
                ---@param key string
                ---@return integer
                function(key)
                    if base_icons[key] then
                        return vim.fn.strdisplaywidth(base_icons[key]) + 2
                    elseif custom_buttons[key] and type(custom_buttons[key].render) == "function" then
                        local ok, icon = pcall(custom_buttons[key].render)
                        if ok and type(icon) == "string" then
                            return vim.fn.strdisplaywidth(icon) + 2
                        end
                    end
                    return 0
                end
            )
            :fold(0, ret_total_length)
    end

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
                labels_len = labels_len
                    or ret_labels_length(
                        vim.tbl_values(winbar.base_sections),
                        vim.tbl_values(winbar.custom_sections)
                    )
                controls_len = controls_len
                    or ret_controls_length(
                        winbar.controls.buttons,
                        winbar.controls.icons,
                        winbar.controls.custom_buttons
                    )
                local width_limit = winbar.controls.enabled and labels_len + controls_len or labels_len
                local width = api.nvim_win_get_width(state.winnr)
                local is_current_section = state.current_section == v
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
