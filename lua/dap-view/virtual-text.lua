local hl = require("dap-view.util.hl")
local setup = require("dap-view.setup")
local state = require("dap-view.state")

local M = {}

local api = vim.api
local ts = vim.treesitter

local ns = require("dap-view.globals").NAMESPACE_VT

---@param bool boolean
---@param session dap.Session?
M.set_virtual_text = function(bool, session)
    setup.config.virtual_text.enabled = bool

    session = session or require("dap").session()

    if session ~= nil then
        M.virtual_text(session.current_frame)
    end
end

---@param frame dap.StackFrame?
M.clear_virtual_text = function(frame)
    if frame and require("dap-view.util.source").source_exists(frame) then
        local buf = vim.uri_to_bufnr(vim.uri_from_fname(frame.source.path))

        api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    else
        for _, buf in ipairs(api.nvim_list_bufs()) do
            api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        end
    end
end

---@param threads table<number, dap.Thread>
M.set_last_frames = function(threads)
    for _, t in pairs(threads or {}) do
        for _, f in ipairs(t.frames or {}) do
            state.last_frames[f.id] = f
        end
    end
end

---@param frame dap.StackFrame?
M.virtual_text = function(frame)
    M.clear_virtual_text(frame)

    local vt_config = setup.config.virtual_text

    if not vt_config.enabled then
        return
    end

    if frame == nil or not require("dap-view.util.source").source_exists(frame) then
        return
    end

    local bufnr = vim.fn.bufnr(frame.source.path, false)
    if bufnr == -1 then
        bufnr = vim.uri_to_bufnr(vim.uri_from_fname(frame.source.path))
    end

    local ft = vim.bo[bufnr].ft

    if ft == "" then
        return
    end

    local lang = ts.language.get_lang(ft)
    if lang == nil then
        return
    end
    local parser = ts.get_parser(bufnr, lang)
    if type(parser) == "string" or parser == nil then
        return
    end

    parser:parse(false, function(_, trees)
        if trees == nil then
            return
        end

        ---@type TSNode[]
        local scope_nodes = {}
        ---@type TSNode[]
        local definition_nodes = {}

        vim.iter(trees):each(
            ---@param tree TSTree
            function(tree)
                -- This probably wouldn't work with injections,
                -- but then, what's the magic adapter that would support them?
                local query = ts.query.get(parser:lang(), "locals")

                if query then
                    for _, match, _ in query:iter_matches(tree:root(), bufnr, 0, -1) do
                        for id, nodes in pairs(match) do
                            for _, node in ipairs(nodes) do
                                local cap_id = query.captures[id]

                                if cap_id:find("scope") then
                                    table.insert(scope_nodes, node)
                                elseif cap_id:find("definition") then
                                    table.insert(definition_nodes, node)
                                end
                            end
                        end
                    end
                end
            end
        )

        ---@type {value: dap.Variable, presentationHint: string}[]
        local variables = {}

        for _, scope in ipairs(frame.scopes or {}) do
            for _, v in pairs(scope.variables or {}) do
                -- TODO OG virtual-text had a workaround for php
                local key = v.name

                -- prefer "locals"
                if not variables[key] or variables[key].presentationHint ~= "locals" then
                    variables[key] = { value = v, presentationHint = scope.presentationHint }
                end
            end
        end

        ---@type table<integer,{[integer]: string, node: TSNode}[]>
        local virt_lines = {}

        ---@type table<string,boolean>
        local node_ids = {}

        local last_scopes = state.last_frames[frame.id] and state.last_frames[frame.id].scopes
        ---@type dap.Variable[]
        local last_variables = {}

        for _, s in ipairs(last_scopes or {}) do
            for _, v in pairs(s.variables or {}) do
                local key = v.name
                -- prefer "locals"
                if not last_variables[key] or last_variables[key].presentationHint ~= "locals" then
                    last_variables[key] = v
                end
            end
        end

        for _, node in ipairs(definition_nodes) do
            local name = ts.get_node_text(node, bufnr)
            local var_line, var_col = node:start()

            local variable = variables[name] and variables[name].value
            local last_variable = last_variables[name] and last_variables[name].value

            -- evaluated local with same name exists
            -- is this name really the local or is it in another scope?
            if variable then
                local in_scope = true
                for _, scope in ipairs(scope_nodes) do
                    if
                        ts.is_in_node_range(scope, var_line, var_col)
                        and not ts.is_in_node_range(scope, frame.line - 1, 0)
                    then
                        in_scope = false
                        break
                    end
                end

                if in_scope then
                    variables[name] = nil

                    local node_id = node:id()

                    if not node_ids[node_id] then
                        node_ids[node_id] = true

                        local has_changed = last_variable and (variable.value ~= last_variable)

                        local text = vt_config.format(variable, frame, node)

                        local type_hl = variable.type and hl.types_to_hl_group[variable.type:lower()]

                        if text then
                            local node_start = node:start()

                            if not virt_lines[node_start] then
                                virt_lines[node_start] = {}
                            end

                            table.insert(virt_lines[node_start], {
                                text,
                                (has_changed and "NvimDapViewVirtualTextUpdated")
                                    or (type_hl and "NvimDapView" .. type_hl .. "Dim")
                                    or "NvimDapViewVirtualText",
                                node = node,
                            })
                        end
                    end
                end
            end
        end

        for _, content in pairs(virt_lines) do
            for _, virt_text in ipairs(content) do
                local node_range = { virt_text.node:range() }

                api.nvim_buf_set_extmark(bufnr, ns, node_range[3], node_range[4], {
                    end_line = node_range[3],
                    end_col = node_range[4],
                    hl_mode = "combine",
                    -- clear extmark after, e.g., commenting the line
                    invalidate = true,
                    virt_text = { { virt_text[1], virt_text[2] } },
                    virt_text_pos = vt_config.position,
                })
            end
        end
    end)
end

return M
