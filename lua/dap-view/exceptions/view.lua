local dap = require("dap")

local state = require("dap-view.state")
local globals = require("dap-view.globals")
local views = require("dap-view.views")
local util = require("dap-view.util")
local hl = require("dap-view.util.hl")
local setup = require("dap-view.setup")

local api = vim.api

local M = {}

M.show = function()
    -- We have to check if the win is valid, since this function may be triggered by an event when the window is closed
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        if views.cleanup_view(not dap.session(), "No active session") then
            return
        end

        ---@type table<string, dapview.ExceptionsOption>
        local adapter_exception_options = state.exceptions_options[state.current_adapter] or {}
        if views.cleanup_view(vim.tbl_isempty(adapter_exception_options), "Not supported by the debug adapter") then
            return
        end

        ---@type table<string,dap.ExceptionFilterOptions>
        local exception_filter_options = state.exception_filter_options_by_adapter[state.current_adapter] or {}

        local icons = setup.config.icons

        ---@type table<integer,string>
        local conditions = {}
        ---@type table<integer,string>
        local condition_descriptions = {}
        ---@type table<integer,integer>
        local description_starts = {}

        local content = vim.iter(adapter_exception_options)
            :enumerate()
            :map(
                ---@param exceptions_option dapview.ExceptionsOption
                ---@return string
                function(k, exceptions_option)
                    local icon = exceptions_option.enabled and icons["enabled"] or icons["disabled"]
                    local filter = exceptions_option.exception_filter

                    local exception_filter_option = exception_filter_options[filter.filter]

                    if filter.supportsCondition and exception_filter_option then
                        if filter.conditionDescription then
                            condition_descriptions[k] = string.format("\tExample: %s", filter.conditionDescription)
                        end
                        conditions[k] = exception_filter_option.condition
                    end

                    local base = " " .. icon .. "  " .. filter.label

                    if filter.description then
                        description_starts[k] = #base + 1
                        base = string.format("%s (%s)", base, filter.description)
                    end

                    return base
                end
            )
            :totable()

        util.set_lines(state.bufnr, 0, -1, false, content)

        for k, condition in pairs(conditions) do
            local condition_description = condition_descriptions[k]
                and { condition_descriptions[k], "NvimDapViewVirtualTextUpdated" }

            api.nvim_buf_set_extmark(state.bufnr, globals.NAMESPACE, k - 1, 0, {
                virt_lines = {
                    {
                        { condition, "NvimDapViewWatchUpdated" },
                        condition_description or nil,
                    },
                },
                virt_lines_overflow = "wrap",
            })
        end

        for i, opt in ipairs(adapter_exception_options) do
            local hl_type = opt.enabled and "Enabled" or "Disabled"
            hl.hl_range("ExceptionFilter" .. hl_type, { i - 1, 0 }, { i - 1, 4 })
        end

        for k, col in pairs(description_starts) do
            hl.hl_range("VirtualText", { k - 1, col }, { k - 1, -1 })
        end
    end
end

return M
