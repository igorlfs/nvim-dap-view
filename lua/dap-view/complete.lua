local setup = require("dap-view.setup")

local M = {}

local ll = vim.log.levels

---@param arg_lead string
---@return string[]
M.complete_sections = function(arg_lead)
    local sections = setup.config.winbar.sections
    return vim.iter(sections)
        :filter(function(section)
            return section:find(arg_lead or "") == 1
        end)
        :totable()
end

---@param cmdline string
---@param cursor_pos number
M.input_completion = function(_, cmdline, cursor_pos)
    local dap = require("dap")
    local session = dap.session()
    if not session or not session.capabilities.supportsCompletionsRequest then
        return {}
    end
    local text = cmdline:sub(1, cursor_pos)
    local words = nil

    session:request("completions", {
        frameId = (session.current_frame or {}).id,
        text = text,
        column = #text + 1,
    }, function(err, response)
        if err then
            vim.notify("completions request failed: " .. err.message, ll.WARN)
            words = {}
            return
        end

        local items = response and response.targets or {}

        table.sort(items, function(a, b)
            return (a.sortText or a.label) < (b.sortText or b.label)
        end)

        local result = {}
        for _, item in ipairs(items) do
            result[#result + 1] = item.text or item.label
        end
        words = result
    end)

    vim.wait(100, function()
        return words ~= nil
    end)

    return words or {}
end

return M
