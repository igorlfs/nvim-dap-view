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

        for k, _ in pairs(state.frames_by_line) do
            state.frames_by_line[k] = nil
        end
        local line = 0
        for _, thread in pairs(state.threads) do
            api.nvim_buf_set_lines(state.bufnr, line, -1, false, { thread.name })
            local is_stopped_thread = state.stopped_thread == thread.id
            hl.hl_range(is_stopped_thread and "ThreadStopped" or "Thread", { line, 0 }, { line, -1 })

            if thread.frames then
                local content = vim.iter(thread.frames):fold(
                    {},
                    ---@param acc string[]
                    ---@param t dap.StackFrame
                    function(acc, t)
                        local show_frame = not t.presentationHint
                            or state.subtle_frames
                            or t.presentationHint ~= "subtle"
                        if show_frame then
                            local path = t.source.path
                            local relative_path = path and vim.fn.fnamemodify(path, ":.") or ""
                            local label = "\t" .. relative_path .. "|" .. t.line .. "|" .. t.name
                            table.insert(acc, label)
                        end
                        return acc
                    end
                )
                line = line + 1

                api.nvim_buf_set_lines(state.bufnr, line, -1, false, content)

                for i, c in pairs(content) do
                    local pipe1 = string.find(c, "|")
                    local pipe2 = #c - string.find(string.reverse(c), "|")

                    state.frames_by_line[line + i] = thread.frames[i]

                    hl.hl_range("FileName", { line - 1 + i, 0 }, { line - 1 + i, pipe1 })
                    hl.hl_range("Separator", { line - 1 + i, pipe1 - 1 }, { line - 1 + i, pipe1 })
                    hl.hl_range("LineNumber", { line - 1 + i, pipe1 }, { line - 1 + i, pipe2 })
                    hl.hl_range("Separator", { line - 1 + i, pipe2 }, { line - 1 + i, pipe2 + 1 })
                end
                line = line + #thread.frames
            else
                line = line + 1
            end
        end
    end
end

return M
