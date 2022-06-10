-- https://github.com/jose-elias-alvarez/null-ls.nvim

local ok, null_ls = pcall(require, "null-ls")
if not ok then
    return
end

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.autopep8,
        null_ls.builtins.formatting.sqlformat,
        null_ls.builtins.formatting.stylua.with({
            extra_args = {
                "--indent-type=Spaces",
                "--indent-width=4",
            },
        }),
    },
})


