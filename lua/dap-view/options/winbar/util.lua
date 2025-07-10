local M = {}

---@param labels string[]
M.get_labels_length = function(labels)
    return vim.iter(labels):fold(0, function(acc, label) ---@param label string
        -- length including margin
        return acc + vim.fn.strdisplaywidth(label) + 2
    end)
end

---@param renders (fun():string)[]
M.get_controls_length = function(renders)
    return vim.iter(renders):fold(0, function(acc, render) ---@param render fun():string
        return acc + vim.fn.strdisplaywidth(render()) + 2
    end)
end

return M
