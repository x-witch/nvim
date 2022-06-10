-- https://github.com/github/copilot.vim

local mapping = require("core.keybinds")


-- Disable default tab completion
vim.g.copilot_no_tab_map = true

mapping.register({
    {
        mode = { "i" },
        lhs = "<c-l>",
        rhs = "copilot#Accept('')",
        options = { silent = true, expr = true },
        description = "Suggestions for using copilot",
    },
})

