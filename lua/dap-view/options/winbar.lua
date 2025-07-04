local state = require("dap-view.state")
local views = require("dap-view.views")
local setup = require("dap-view.setup")
local controls = require("dap-view.options.controls")
local statusline = require("dap-view.util.statusline")
local util = require("dap-view.util")
local guard = require("dap-view.guard")
local module = ...

local M = {}

local api = vim.api

local winbar_info = {
    breakpoints = {
        keymap = "B",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "breakpoints") then
                views.switch_to_view("breakpoints")
            end
        end,
    },
    scopes = {
        keymap = "S",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "scopes") then
                views.switch_to_view("scopes")
            end
        end,
    },
    exceptions = {
        keymap = "E",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "exceptions") then
                views.switch_to_view("exceptions")
            end
        end,
    },
    watches = {
        keymap = "W",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "watches") then
                views.switch_to_view("watches")
            end
        end,
    },
    threads = {
        keymap = "T",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "threads") then
                views.switch_to_view("threads")
            end
        end,
    },
    repl = {
        keymap = "R",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "repl") then
                if not util.is_win_valid(state.winnr) then
                    return
                end
                -- Jump to dap-view's window to make the experience seamless
                local cmd = "lua vim.api.nvim_set_current_win(" .. state.winnr .. ")"
                local repl_buf, _ = require("dap").repl.open(nil, cmd)
                -- The REPL is a new buffer, so we need to set the winbar keymaps again
                M.set_winbar_action_keymaps(repl_buf)
                M.update_section("repl")
            end
        end,
    },
    console = {
        keymap = "C",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "console") then
                if not util.is_win_valid(state.winnr) or not guard.expect_session() then
                    return
                end

                assert(state.current_session_id, "has active session")

                api.nvim_win_call(state.winnr, function()
                    api.nvim_set_current_buf(state.term_bufnrs[state.current_session_id])
                end)

                require("dap-view.term.options").set_win_options(state.winnr)

                M.update_section("console")
            end
        end,
    },
}

---@param bufnr? integer
M.set_winbar_action_keymaps = function(bufnr)
    if bufnr or state.bufnr then
        for _, value in pairs(winbar_info) do
            vim.keymap.set("n", value.keymap, function()
                value.action()
            end, { buffer = bufnr or state.bufnr })
        end
    end
end

---@param idx integer
M.on_click = function(idx)
    local key = setup.config.winbar.sections[idx]
    local section = winbar_info[key]
    section.action()
end

local set_winbar_opt = function()
    if util.is_win_valid(state.winnr) then
        local winbar = setup.config.winbar.sections
        local winbar_title = {}
        local controls_config = setup.config.winbar.controls

        if controls_config.enabled and controls_config.position == "left" then
            table.insert(winbar_title, controls.render() .. "%=")
        end

        for idx, key in ipairs(winbar) do
            local info = winbar_info[key]

            if info ~= nil then
                local desc = " " .. setup.config.winbar.headers[key] .. " "
                desc = statusline.clickable(desc, module, "on_click", idx)

                if state.current_section == key then
                    desc = statusline.hl(desc, "TabSelected")
                else
                    desc = statusline.hl(desc, "Tab")
                end

                table.insert(winbar_title, desc)
            end
        end

        if controls_config.enabled and controls_config.position == "right" then
            table.insert(winbar_title, "%=" .. controls.render())
        end

        local value = table.concat(winbar_title, "")

        vim.wo[state.winnr][0].winbar = value
    end
end

---@param selected_section dapview.SectionType
M.show_content = function(selected_section)
    winbar_info[selected_section].action()
end

---@param section_name dapview.SectionType
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
