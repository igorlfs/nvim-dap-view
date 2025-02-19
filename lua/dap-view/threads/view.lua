local dap = require("dap")

local winbar = require("dap-view.options.winbar")
local views = require("dap-view.views")
local state = require("dap-view.state")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

M.show = function()
    winbar.update_winbar("threads")

    if state.bufnr then
        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, 0, -1, true, {})

        if views.cleanup_view(not dap.session(), "No active session") then
            return
        end

        if state.threads_err then
            api.nvim_buf_set_lines(state.bufnr, 0, -1, false, { "Failed to get threads", state.threads_err })
            return
        end

        if views.cleanup_view(vim.tbl_isempty(state.threads), "Debug adapter returned no threads") then
            return
        end

        local line = 0
        for _, thread in pairs(state.threads) do
            api.nvim_buf_set_lines(state.bufnr, line, -1, false, { thread.name })
            hl.hl_range("NvimDapViewThread", { line, 0 }, { line, -1 })

            if thread.frames then
                local content = vim.iter(thread.frames):fold(
                    {},
                    ---@param acc string[]
                    ---@param t dap.StackFrame
                    function(acc, t)
                        if not t.presentationHint or t.presentationHint ~= "subtle" then
                            local path = t.source.path
                            local relative_path = path and vim.fn.fnamemodify(path, ":.") or ""
                            local label = "\t" .. relative_path .. "|" .. t.line .. "|" .. t.name
                            table.insert(acc, label)
                        end
                        return acc
                    end
                )

                api.nvim_buf_set_lines(state.bufnr, line + 1, -1, false, content)

                for i, c in pairs(content) do
                    local pipe1 = string.find(c, "|")
                    local pipe2 = #c - string.find(string.reverse(c), "|")

                    hl.hl_range("NvimDapViewFileName", { line + i, 0 }, { line + i, pipe1 })
                    hl.hl_range("NvimDapViewSeparator", { line + i, pipe1 - 1 }, { line + i, pipe1 })
                    hl.hl_range("NvimDapViewLineNumber", { line + i, pipe1 }, { line + i, pipe2 })
                    hl.hl_range("NvimDapViewSeparator", { line + i, pipe2 }, { line + i, pipe2 + 1 })
                end
            end

            line = line + #thread.frames + 1
        end
    end
end

return M
