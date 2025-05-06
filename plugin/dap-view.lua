local command = vim.api.nvim_create_user_command

command("DapViewOpen", function()
    require("dap-view").open()
end, {})
command("DapViewClose", function(opts)
    require("dap-view").close(opts.bang)
end, { bang = true })
command("DapViewToggle", function(opts)
    require("dap-view").toggle(opts.bang)
end, { bang = true })
command("DapViewWatch", function()
    require("dap-view").add_expr()
end, {})
command("DapViewJump", function(opts)
    require("dap-view").jump_to_view(opts.fargs[1])
end, {
    nargs = 1,
    complete = function(argLead, _, _)
        local sections = require('dap-view.config').config.winbar.sections
        return vim.iter(sections):filter(function(section)
            return section:find(argLead or "") == 1
        end):totable()
    end
})
command("DapViewShow", function(opts)
    require("dap-view").show_view(opts.fargs[1])
end, { nargs = 1 })
