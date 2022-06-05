-- https://github.com/jose-elias-alvarez/null-ls.nvim

local path_join = require("core.utils").path_join
local options = require("core.default_config").options

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
        -- null_ls.builtins.diagnostics.pylint.with({
        --     extra_args = {
        --         "-f",
        --         "json",
        --         "--load-plugins=pylint_django",
        --         "--disable=django-not-configured",
        --         "--rcfile=" .. path_join(options.nvim_lint_dir, "pylint.conf"),
        --     },
        -- }),
    },
})


