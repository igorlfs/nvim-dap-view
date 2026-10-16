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

---@param text string
---@param arg_lead string
---@return integer
local function arg_lead_offset(text, arg_lead)
    for i = #text, 0, -1 do
        if (i == 0 or text:sub(i, i):match("%s")) and text:sub(i + 1, i + #arg_lead) == arg_lead then
            return i
        end
    end
    return 0
end

---@param arg_lead string
---@param cmdline string
---@param cursor_pos number
M.input_completion = function(arg_lead, cmdline, cursor_pos)
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

        local word_start = vim.fn.match(text, [[\k*$]])
        local lead_start = arg_lead_offset(text, arg_lead or "")

        local result = {}
        for _, item in ipairs(items) do
            local new_text = item.text or item.label

            local start, finish = word_start, #text
            if item.start and (item.length or 0) > 0 then
                start = item.start
                finish = item.start + item.length
            end

            local full = text:sub(1, start) .. new_text .. text:sub(finish + 1)

            if full:sub(1, lead_start) == text:sub(1, lead_start) then
                full = full:sub(lead_start + 1)
            end

            result[#result + 1] = full
        end
        words = result
    end)

    vim.wait(100, function()
        return words ~= nil
    end)

    return words or {}
end

return M
