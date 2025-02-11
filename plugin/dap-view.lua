local command = vim.api.nvim_create_user_command

command("DapViewOpen", require("dap-view").open, {})
command("DapViewClose", require("dap-view").close, {})
command("DapViewHide", require("dap-view").hide, {})
command("DapViewToggle", require("dap-view").toggle, {})
command("DapViewWatch", require("dap-view").add_expr, {})
