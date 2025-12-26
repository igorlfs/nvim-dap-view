local dap = require("dap")

local views = require("dap-view.views")
local util = require("dap-view.util")
local state = require("dap-view.state")
local hl = require("dap-view.util.hl")
local setup = require("dap-view.setup")

local M = {}

M.show = function()
    -- We have to check if the win is valid, since this function may be triggered by an event when the window is closed
    if util.is_buf_valid(state.bufnr) and util.is_win_valid(state.winnr) then
        local session = dap.session()

        if views.cleanup_view(session == nil, "No active session") then
            return
        end

        ---@cast session dap.Session
        if views.cleanup_view(state.threads_error ~= nil, state.threads_error) then
            return
        end

        if views.cleanup_view(session.stopped_thread_id == nil, "No stopped thread") then
            return
        end

        if views.cleanup_view(vim.tbl_isempty(session.threads), "Debug adapter returned no threads") then
            return
        end

        for k, _ in pairs(state.frames_by_line) do
            state.frames_by_line[k] = nil
        end

        local line = 0

        if state.threads_filter ~= "" then
            local filter = setup.config.icons["filter"] .. " "
            local filter_icon_len = #filter

            filter = filter .. state.threads_filter

            local omit_icon_len = 0

            if state.threads_filter_invert then
                local omit_icon = " " .. setup.config.icons["negate"]
                omit_icon_len = #omit_icon
                filter = filter .. omit_icon
            end

            util.set_lines(state.bufnr, line, line, true, { filter })

            hl.hl_range("FrameCurrent", { 0, 0 }, { 0, filter_icon_len })

            if state.threads_filter_invert then
                hl.hl_range("MissingData", { 0, #filter - omit_icon_len }, { 0, #filter })
            end

            line = line + 1
        end

        for k, thread in pairs(session.threads) do
            local is_stopped_thread = session.stopped_thread_id == thread.id
            local thread_name = is_stopped_thread and thread.name .. " " .. setup.config.icons["pause"] or thread.name
            util.set_lines(state.bufnr, line, line, true, { thread_name })

            hl.hl_range(is_stopped_thread and "ThreadStopped" or "Thread", { line, 0 }, { line, -1 })

            line = line + 1

            local valid_frames = vim.iter(thread.frames or {})
                :filter(
                    ---@param f dap.StackFrame
                    function(f)
                        return f.source ~= nil and f.source.path ~= nil and vim.uv.fs_stat(f.source.path) ~= nil
                    end
                )
                :totable()

            if vim.tbl_isempty(valid_frames) then
                local thread_err = state.stack_trace_errors[k]
                if thread_err then
                    util.set_lines(state.bufnr, line, line, true, { thread_err })
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
                            local path = f.source and f.source.path
                            local relative_path = path and vim.fn.fnamemodify(path, ":.") or ""
                            local label = "\t" .. relative_path .. "|" .. f.line .. "|" .. f.name

                            table.insert(acc, { label = label, id = f.id })
                        end
                        return acc
                    end
                )

                local filtered_frames = vim.iter(frames)
                    :filter(
                        ---@param f {label: string, id: number}
                        function(f)
                            local match = f.label:match(state.threads_filter)
                            local invert = state.threads_filter_invert
                            return state.threads_filter == "" or (invert and not match) or (not invert and match)
                        end
                    )
                    :totable()

                local content = vim.iter(filtered_frames)
                    :map(
                        ---@param f {label: string, id: number}
                        function(f)
                            return f.label
                        end
                    )
                    :totable()

                util.set_lines(state.bufnr, line, line + #content, false, content)

                for i, f in pairs(filtered_frames) do
                    local first_pipe_pos = string.find(f.label, "|")
                    assert(first_pipe_pos, "missing pipe, buffer may have been edited")

                    local last_pipe = string.find(string.reverse(f.label), "|")
                    assert(last_pipe, "missing pipe, buffer may have been edited")

                    local last_pipe_pos = #f.label - last_pipe

                    hl.highlight_file_name_and_line_number(
                        line + i - 1,
                        first_pipe_pos - 1,
                        last_pipe_pos - first_pipe_pos
                    )

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
        util.set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
