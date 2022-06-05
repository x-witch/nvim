-- https://github.com/kristijanhusak/vim-dadbod-ui

local toggle_sidebar = require("core.utils")
local options = require("core.default_config").options
local mapping = require("core.mappings")



vim.g.dbs = options.database_config
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
            toggle_sidebar("dbui")
            vim.cmd("DBUIToggle")
        end,
        options = { silent = true },
        description = "Open Database Explorer",
    },
})

