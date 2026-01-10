local M = {}

---@param append boolean
M.new_expression = function(append)
    vim.ui.input({ prompt = "Expression: " }, function(input)
        if input then
            coroutine.wrap(function()
                if require("dap-view.watches.actions").add_watch_expr(input, true, append) then
                    require("dap-view.views").switch_to_view("watches")
                end
            end)()
        end
    end)
end

return M
