local M = {}

M.split_string_to_table = function(str)
    local lines = {}
    for line in str:gmatch("([^\n]*)\n?") do
        if line ~= "" then
            table.insert(lines, line)
        end
    end
    return lines
end

return M
