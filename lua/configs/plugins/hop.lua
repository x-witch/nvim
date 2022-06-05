-- https://github.com/phaazon/hop.nvim

local mapping = require("core.mappings")

local ok, hop = pcall(require, "hop")
if not ok then
    return
end

hop.setup({
    -- Assign key
    { keys = "qwertyuiopasdfghjklzxcvbnm" }
})

mapping.register({
    {
        mode = { "n", "v" },
        lhs = "ss",
        rhs = "<cmd>HopWord<cr>",
        options = { silent = true },
        description = "Jump to word head",
    },
    {
        mode = { "n", "v" },
        lhs = "sl",
        rhs = "<cmd>HopLine<cr>",
        options = { silent = true },
        description = "Jump to line",
    },
    {
        mode = { "n", "v" },
        lhs = "sf",
        rhs = "<cmd>HopChar1<cr>",
        options = { silent = true },
        description = "Jump to search char on buffer",
    },
    {
        mode = { "n", "v" },
        lhs = "sc",
        rhs = "<cmd>HopChar1CurrentLine<cr>",
        options = { silent = true },
        description = "Jump to search char on current line",
    },
})

