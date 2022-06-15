-- https://github.com/phaazon/hop.nvim

local status_ok, hop = pcall(require, 'hop')
if not status_ok then
    vim.notify('hop not found')
    return
end

local mapping = require("core.keybinds")

hop.setup({
    keys = 'etovxqpdygfblzhckisuran'
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

