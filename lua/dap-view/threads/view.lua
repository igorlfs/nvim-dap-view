local dap = require("dap")

local views = require("dap-view.views")
local state = require("dap-view.state")
local hl = require("dap-view.util.hl")

local M = {}

local api = vim.api

M.show = function()
    if state.bufnr and state.winnr then
        local session = dap.session()

        if views.cleanup_view(session == nil, "No active session") then
            return
        end

        ---@cast session dap.Session
        if views.cleanup_view(state.threads_error ~= nil, state.threads_error) then
            return
        end

        if views.cleanup_view(vim.tbl_isempty(session.threads), "Debug adapter returned no threads") then
            return
        end

        for k, _ in pairs(state.frames_by_line) do
            state.frames_by_line[k] = nil
        end

        local line = 0

        for k, thread in pairs(session.threads) do
            local is_stopped_thread = session.stopped_thread_id == thread.id
            local thread_name = is_stopped_thread and thread.name .. " " or thread.name
            api.nvim_buf_set_lines(state.bufnr, line, line, true, { thread_name })

            hl.hl_range(is_stopped_thread and "ThreadStopped" or "Thread", { line, 0 }, { line, -1 })

            line = line + 1

            local valid_frames = vim.iter(thread.frames or {})
                :filter(
                    ---@param f dap.StackFrame
                    function(f)
                        return f.source ~= nil
                            and f.source.path ~= nil
                            and vim.uv.fs_stat(f.source.path) ~= nil
                    end
                )
                :totable()

            if vim.tbl_isempty(valid_frames) then
                local thread_err = state.stack_trace_errors[k]
                if thread_err then
                    api.nvim_buf_set_lines(state.bufnr, line, line, true, { thread_err })
                    hl.hl_range("ThreadError", { line, 0 }, { line, -1 })
                    line = line + 1
                end
            else
                ---@type {label: string, id: number}[]
                local frames = vim.iter(valid_frames):fold(
                    {},
                    ---@param acc string[]
                    ---@param f dap.StackFrame
                    function(acc, f)
                        local show_frame = not f.presentationHint
                            or state.subtle_frames
                            or f.presentationHint ~= "subtle"
                        if show_frame then
                            local path = f.source.path
                            local relative_path = path and vim.fn.fnamemodify(path, ":.") or ""
                            local label = "\t" .. relative_path .. "|" .. f.line .. "|" .. f.name

                            table.insert(acc, { label = label, id = f.id })
                        end
                        return acc
                    end
                )

                local content = vim.iter(frames)
                    :map(
                        ---@param f {label: string, id: number}
                        function(f)
                            return f.label
                        end
                    )
                    :totable()

                api.nvim_buf_set_lines(state.bufnr, line, line + #content, false, content)

                for i, f in pairs(frames) do
                    local pipe1 = string.find(f.label, "|")
                    local pipe2 = #f.label - string.find(string.reverse(f.label), "|")

                    hl.highlight_file_name_and_line_number(line + i - 1, pipe1 - 1, pipe2 - pipe1)

                    if session.current_frame and f.id == session.current_frame.id then
                        hl.hl_range("FrameCurrent", { line + i - 1, 0 }, { line + i - 1, -1 })
                    end

                    -- We can't index directly here, because we filter the valid_frames on the show_frame condition
                    -- That means the indexes may not match
                    state.frames_by_line[line + i] = vim.iter(valid_frames):find(
                        ---@param f_ dap.StackFrame
                        function(f_)
                            return f.id == f_.id
                        end
                    )
                end

                line = line + #content
            end
        end

        -- Clear previous content
        api.nvim_buf_set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
