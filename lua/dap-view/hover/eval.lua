local state = require("dap-view.state")

local M = {}

---@alias dapview.EvaluateContext "watch" | "repl" | "hover" | "clipboard" | "variables" | string

---@class dapview.EvaluateOpts
---@field context dapview.EvaluateContext

---@param expression string
---@param context dapview.EvaluateContext?
M.evaluate_expression = function(expression, context)
    local session = assert(require("dap").session(), "has active session")

    local frame_id = session.current_frame and session.current_frame.id

    context = context or session.capabilities.supportsEvaluateForHovers and "hover" or "repl"

    local err, response =
        session:request("evaluate", { expression = expression, context = context, frameId = frame_id })

    local expanded = not state.hovered_expression or state.hovered_expression.expanded

    state.hovered_expression = { response = response, err = err, expanded = expanded }
end

return M
