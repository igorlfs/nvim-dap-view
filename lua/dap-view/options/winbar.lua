local state = require("dap-view.state")
local setup = require("dap-view.setup")

local M = {}

local winbar_info = {
    breakpoints = {
        desc = "Breakpoints [B]",
        keymap = "B",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "breakpoints") then
                require("dap-view.views").switch(function()
                    require("dap-view.breakpoints.view").show()
                end)
            end
        end,
    },
    exceptions = {
        desc = "Exceptions [E]",
        keymap = "E",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "exceptions") then
                require("dap-view.views").switch(function()
                    require("dap-view.exceptions.view").show()
                end)
            end
        end,
    },
    watches = {
        desc = "Watches [W]",
        keymap = "W",
        action = function()
            if vim.tbl_contains(setup.config.winbar.sections, "watches") then
                require("dap-view.views").switch(function()
                    require("dap-view.watches.view").show()
                end)
            end
        end,
    },
    repl = {
        desc = "REPL [R]",
        keymap = "R",
        action = function()
            local winnr = state.winnr
            -- Jump to dap-view's window to make the experience seamless
            local cmd = "lua vim.api.nvim_set_current_win(" .. winnr .. ")"
            local repl_buf, _ = require("dap").repl.open(nil, cmd)
            -- The REPL is a new buffer, so we need to set the winbar keymaps again
            M.set_winbar_action_keymaps(repl_buf)
            M.update_winbar("repl")
        end,
    },
}

---@param bufnr? integer
M.set_winbar_action_keymaps = function(bufnr)
    if state.bufnr then
        for _, value in pairs(winbar_info) do
            vim.keymap.set("n", value.keymap, function()
                value.action()
            end, { buffer = bufnr or state.bufnr })
        end
    end
end

---@param selected_section SectionType
local set_winbar_opt = function(selected_section)
    if state.winnr then
        local winbar = setup.config.winbar.sections
        local winbar_title = {}

        for _, key in ipairs(winbar) do
            local info = winbar_info[key]

            if info ~= nil then
                local desc = info.desc .. " %*"

                if selected_section == key then
                    desc = "%#TabLineSel# " .. desc
                else
                    desc = "%#TabLine# " .. desc
                end

                table.insert(winbar_title, desc)
            end
        end

        local value = table.concat(winbar_title, "")

        vim.wo[state.winnr][0].winbar = value
    end
end

---@param selected_section? SectionType
M.show_content = function(selected_section)
    winbar_info[selected_section].action()
end

---@param section_name SectionType
local _update_winbar = function(section_name)
    state.current_section = section_name
    set_winbar_opt(state.current_section)
end

---@param section_name SectionType
M.update_winbar = function(section_name)
    if setup.config.winbar.show then
        _update_winbar(section_name)
    end
end

return M
