local command = vim.api.nvim_create_user_command

command("DapViewOpen", require("dap-view").open, {})
command("DapViewClose", function(opts)
    if opts.bang then
        require("dap-view").hide()
    else
        require("dap-view").close()
    end
end, { bang = true })
command("DapViewToggle", require("dap-view").toggle, {})
command("DapViewWatch", require("dap-view").add_expr, {})
