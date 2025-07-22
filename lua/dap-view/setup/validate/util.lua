local M = {}

-- Code taken from @MariaSolOs in a indent-blankline.nvim PR:
-- https://github.com/lukas-reineke/indent-blankline.nvim/pull/934/files#diff-09ebcaa8c75cd1e92d25640e377ab261cfecaf8351c9689173fd36c2d0c23d94R16

--- @param spec table<string, {[1]:any, [2]:vim.validate.Validator, [3]:string|true|nil}>
local _validate = function(spec)
    for key, key_spec in pairs(spec) do
        local message = type(key_spec[3]) == "string" and key_spec[3] or nil --[[@as string?]]
        local optional = type(key_spec[3]) == "boolean" and key_spec[3] or nil --[[@as boolean?]]
        vim.validate(key, key_spec[1], key_spec[2], optional, message)
    end
end

--- @param path string The path to the field being validated
--- @param tbl table The table to validate
--- @param source table The original table that we're validating against
--- @see vim.validate
function M.validate(path, tbl, source)
    -- Validate
    local _, err = pcall(_validate, tbl)
    if err then
        error(path .. "." .. err)
    end

    -- Check for erroneous fields
    for k, _ in pairs(source) do
        if tbl[k] == nil then
            error(path .. "." .. k .. ": unexpected field found in configuration")
        end
    end
end

return M
