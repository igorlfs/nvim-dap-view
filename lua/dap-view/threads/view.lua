local dap = require("dap")

local globals = require("dap-view.globals")
local views = require("dap-view.views")
local util = require("dap-view.util")
local state = require("dap-view.state")
local hl = require("dap-view.util.hl")
local setup = require("dap-view.setup")

local M = {}

local api = vim.api

---@class dapview.Frame
---@field path string
---@field lnum string
---@field name string
---@field id number

---@class dapview.FrameContent
---@field content dapview.Content[]
---@field id number

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
        for k, _ in pairs(state.frame_paths_by_frame_id) do
            state.frame_paths_by_frame_id[k] = nil
        end
        for k, _ in pairs(state.frame_line_by_frame_id) do
            state.frame_line_by_frame_id[k] = nil
        end

        local line = 0
        local config = setup.config

        if state.threads_filter ~= "" then
            local filter = config.icons["filter"] .. " "
            local filter_icon_len = #filter

            filter = filter .. state.threads_filter

            local omit_icon_len = 0

            if state.threads_filter_invert then
                local omit_icon = " " .. config.icons["negate"]
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

        local has_no_filter = state.threads_filter == ""

        ---@type integer[][]
        local lengths = {}

        local num_parts = 0

        ---@type integer[]
        local row_offsets = {}

        local row_offset = 0

        for k, thread in pairs(session.threads) do
            row_offset = row_offset + 1

            local is_stopped_thread = session.stopped_thread_id == thread.id
            local thread_name = is_stopped_thread and thread.name .. " " .. config.icons["pause"] or thread.name
            util.set_lines(state.bufnr, line, line, true, { thread_name })

            hl.hl_range(is_stopped_thread and "ThreadStopped" or "Thread", { line, 0 }, { line, -1 })

            line = line + 1

            ---@type dap.StackFrame[]
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
                ---@type dapview.Frame[]
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

                            state.frame_paths_by_frame_id[f.id] = relative_path
                            state.frame_line_by_frame_id[f.id] = f.line

                            table.insert(acc, {
                                path = relative_path,
                                lnum = tostring(f.line),
                                name = f.name,
                                id = f.id,
                            })
                        end
                        return acc
                    end
                )

                local formatted_frames = vim.iter(frames):map(
                    ---@param frame dapview.Frame
                    function(frame)
                        local format = config.render.threads.format(frame.name, frame.lnum, frame.path)

                        for _, p in ipairs(format) do
                            assert(
                                not p.separator or #p.separator == 1,
                                "Separator length must not exceeed 1 character"
                            )
                        end

                        num_parts = #format - 1

                        lengths[#lengths + 1] = vim.iter(format)
                            :map(
                                ---@param part dapview.Content
                                function(part)
                                    return #part.text
                                end
                            )
                            :totable()

                        row_offsets[#row_offsets + 1] = row_offset

                        return { content = format, id = frame.id }
                    end
                )

                ---@type dapview.FrameContent[]
                local filtered_frames = formatted_frames
                    :filter(
                        ---@param f dapview.FrameContent
                        function(f)
                            local label = ""
                            for _, l in ipairs(f.content) do
                                label = label .. l.text
                            end
                            local match = label:match(state.threads_filter)
                            local invert = state.threads_filter_invert
                            return has_no_filter or (invert and not match) or (not invert and match)
                        end
                    )
                    :totable()

                ---@type string[]
                local content = vim.iter(filtered_frames)
                    :map(
                        ---@param f dapview.FrameContent
                        function(f)
                            local label = "\t"
                            for n, l in ipairs(f.content) do
                                label = label .. l.text
                                if n ~= #f.content then
                                    label = label .. (l.separator or "|")
                                end
                            end
                            return label
                        end
                    )
                    :totable()

                util.set_lines(state.bufnr, line, line + #content, false, content)

                for i, f in pairs(filtered_frames) do
                    local actual_line = line + i - 1

                    if session.current_frame and f.id == session.current_frame.id then
                        api.nvim_buf_set_extmark(state.bufnr, globals.NAMESPACE, actual_line, 0, {
                            line_hl_group = "NvimDapViewFrameCurrent",
                        })
                    else
                        local hl_init = 1
                        for _, p in ipairs(f.content) do
                            local hl_end = hl_init + #p.text

                            if type(p.hl) == "string" then
                                ---@cast p {hl: string}
                                hl.hl_range(p.hl, { actual_line, hl_init }, { actual_line, hl_end })
                            end

                            hl.hl_range("Separator", { actual_line, hl_end }, { actual_line, hl_end + 1 })

                            hl_init = hl_init + #p.text + 1
                        end
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

        if setup.config.render.breakpoints.align then
            require("dap-view.util.align").align(num_parts, lengths, 1, row_offsets)
        end

        -- Clear previous content
        util.set_lines(state.bufnr, line, -1, true, {})
    end
end

return M
