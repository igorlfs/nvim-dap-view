local command = vim.api.nvim_create_user_command

command("DapViewOpen", require("dap-view").open, {})
command("DapViewClose", function(opts)
    require("dap-view").close(opts.bang)
end, { bang = true })
command("DapViewToggle", function(opts)
    require("dap-view").toggle(opts.bang)
end, { bang = true })
command("DapViewWatch", require("dap-view").add_expr, {})
command("DapViewJump", function(opts)
    require("dap-view").jump_to_view(opts.fargs[1])
end, { nargs = 1 })
