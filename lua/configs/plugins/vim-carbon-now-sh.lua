-- https://github.com/kristijanhusak/vim-carbon-now-sh

local mapping = require("core.keybinds")

mapping.register({
    {
        mode = { "v" },
        lhs = "<leader>ci",
        rhs = ":CarbonNowSh<cr>",
        options = { silent = true },
        description = "Code screenshot",
    },
    {
        mode = { "n" },
        lhs = "<leader>ci",
        rhs = "ggVG:CarbonNowSh<cr>",
        options = { silent = true },
        description = "Code screenshot",
    },
})

