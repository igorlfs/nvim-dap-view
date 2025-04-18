local highlight = require("dap-view.highlight")
local state = require("dap-view.state")
local setup = require("dap-view.setup")
local controls = require("dap-view.options.controls")
local module = ...

local M = {}

local api = vim.api

local winbar_info = {
    breakpoints = {
        keymap = "B",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "breakpoints") then
                require("dap-view.views").switch_to_view(require("dap-view.breakpoints.view").show)
            end
        end,
    },
    scopes = {
        keymap = "S",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "scopes") then
                require("dap-view.views").switch_to_view(require("dap-view.scopes.view").show)
            end
        end,
    },
    exceptions = {
        keymap = "E",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "exceptions") then
                require("dap-view.views").switch_to_view(require("dap-view.exceptions.view").show)
            end
        end,
    },
    watches = {
        keymap = "W",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "watches") then
                require("dap-view.views").switch_to_view(require("dap-view.watches.view").show)
            end
        end,
    },
    threads = {
        keymap = "T",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "threads") then
                require("dap-view.views").switch_to_view(require("dap-view.threads.view").show)
            end
        end,
    },
    repl = {
        keymap = "R",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "repl") then
                -- Jump to dap-view's window to make the experience seamless
                local cmd = "lua vim.api.nvim_set_current_win(" .. state.winnr .. ")"
                local repl_buf, _ = require("dap").repl.open(nil, cmd)
                -- The REPL is a new buffer, so we need to set the winbar keymaps again
                M.set_winbar_action_keymaps(repl_buf)
                M.update_winbar("repl")
            end
        end,
    },
    console = {
        keymap = "C",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "console") then
                if not state.term_bufnr then
                    require("dap-view.term.init").setup_term_win_cmd()
                end

                api.nvim_win_call(state.winnr, function()
                    api.nvim_set_current_buf(state.term_bufnr)
                end)

                require("dap-view.term.options").set_options(state.winnr, state.term_bufnr)

                M.set_winbar_action_keymaps(state.term_bufnr)
                M.update_winbar("console")
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

---@param selected_section SectionType
local set_winbar_opt = function(selected_section)
    if state.winnr and api.nvim_win_is_valid(state.winnr) then
        local winbar = setup.config.winbar.sections
        local winbar_title = {}

        if controls.enabled_left() then
            table.insert(winbar_title, controls.render() .. "%=")
        end

        for idx, key in ipairs(winbar) do
            local info = winbar_info[key]

            if info ~= nil then
                local desc = " " .. setup.config.winbar.headers[key] .. " "
                desc = highlight.clickable(desc, module, "on_click", idx)

                if selected_section == key then
                    desc = highlight.hl(desc, "TabSelected")
                else
                    desc = highlight.hl(desc, "Tab")
                end

                table.insert(winbar_title, desc)
            end
        end

        if controls.enabled_right() then
            table.insert(winbar_title, "%=" .. controls.render())
        end

        local value = table.concat(winbar_title, "")

        vim.wo[state.winnr][0].winbar = value
    end
end

---@param selected_section SectionType
M.show_content = function(selected_section)
    winbar_info[selected_section].action()
end

---@param section_name? SectionType
M.update_winbar = function(section_name)
    if setup.config.winbar.show then
        state.current_section = section_name or state.current_section
        set_winbar_opt(state.current_section)
    end
end

return M
