-- https://github.com/kristijanhusak/vim-dadbod-ui

local mapping = require("core.keybinds")

local database_config = {
    {
        name = "dev",
        url = "mysql://nrnn@192.168.0.120/db1",
    },
    {
        name = "local",
        url = "mysql://root@localhost:3306/test",
    },
}

vim.g.dbs = database_config
-- width
vim.g.db_ui_winwidth = 30
-- automatically execute built-in statements
vim.g.db_ui_auto_execute_table_helpers = true
-- do not automatically query when saving
vim.g.db_ui_execute_on_save = false

mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>4",
        -- rhs = ":NvDBUIToggle<cr>",
        rhs = function()
            vim.cmd("DBUIToggle")
        end,
        options = { silent = true },
        description = "Open Database Explorer",
    },
})

