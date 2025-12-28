local api = vim.api

local command = api.nvim_create_user_command

command("DapViewOpen", function()
    require("dap-view").open()
end, {})
command("DapViewClose", function(opts)
    require("dap-view").close(opts.bang)
end, { bang = true })
command("DapViewToggle", function(opts)
    require("dap-view").toggle(opts.bang)
end, { bang = true })
command("DapViewWatch", function(opts)
    local expr = nil
    if opts.range > 0 then
        expr = require("dap-view.util.exprs").get_trimmed_selection()
    elseif #opts.fargs > 0 then
        expr = table.concat(opts.fargs, " ")
    end
    require("dap-view").add_expr(expr)
end, {
    nargs = "*",
    range = true,
})
command("DapViewJump", function(opts)
    require("dap-view").jump_to_view(opts.fargs[1])
end, {
    nargs = 1,
    ---@param arg_lead string
    complete = function(arg_lead)
        return require("dap-view.complete").complete_sections(arg_lead)
    end,
})
command("DapViewShow", function(opts)
    require("dap-view").show_view(opts.fargs[1])
end, {
    nargs = 1,
    ---@param arg_lead string
    complete = function(arg_lead)
        return require("dap-view.complete").complete_sections(arg_lead)
    end,
})
command("DapViewNavigate", function(opts)
    require("dap-view").navigate({ wrap = opts.bang, count = tonumber(opts.fargs[1]) or 1 })
end, {
    nargs = 1,
    bang = true,
})

api.nvim_create_autocmd("SessionLoadPost", {
    callback = function()
        require("dap-view.vim-sessions").load_session_hook()
    end,
})
