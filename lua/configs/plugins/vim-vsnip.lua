-- https://github.com/L3MON4D3/LuaSnip

local mapping = require("core.keybinds")

vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
vim.g.vsnip_filetypes = {
    javascript = { "typescript" },
    typescript = { "javascript" },
    vue = { "javascript", "typescript" },
}

mapping.register({
    {
        mode = { "i", "s" },
        lhs = "<tab>",
        rhs = "vsnip#jumpable(1)? '<Plug>(vsnip-jump-next)':'<tab>'",
        options = { silent = true, expr = true },
        description = "Jump to the next fragment placeholder",
    },
    {
        mode = { "i", "s" },
        lhs = "<s-tab>",
        rhs = "vsnip#jumpable(-1)?'<Plug>(vsnip-jump-prev)':'<s-tab>'",
        options = { silent = true, expr = true },
        description = "Jump to the prev fragment placeholder",
    },
})

