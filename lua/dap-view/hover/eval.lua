local state = require("dap-view.state")

local M = {}

---@param expression string
M.evaluate_expression = function(expression)
    local session = assert(require("dap").session(), "has active session")

    local frame_id = session.current_frame and session.current_frame.id

    local context = session.capabilities.supportsEvaluateForHovers and "hover" or "repl"

    local err, response =
        session:request("evaluate", { expression = expression, context = context, frameId = frame_id })

    local expanded = not state.hovered_expression or state.hovered_expression.expanded

    state.hovered_expression = { response = response, err = err, expanded = expanded }
end

return M
