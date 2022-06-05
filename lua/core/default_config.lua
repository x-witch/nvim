local M = {}

M.options = {
    -- Auto save Buffer
    auto_save_buffer = true,
    -- Automatically switch input method, currently only for Linux and Fcitx5
    auto_switch_input = true,
    --  Icon style to use
    -- • vscode (requires condicon.ttf installed)
    -- • kind (default)options.
    icons_style = "kind",
    -- theme style to use
    -- • catppuccin
    -- • vscode
    -- • github-theme
    colorscheme = "catppuccin",
    -- Whether the background is transparent
    -- • boolean
    transparent_background = false,
    -- lint configuration file
    -- • string
    nvim_lint_dir = vim.fn.stdpath("config") .. "lint",
    -- Code snippet storage directory
    -- • string
    code_snippets_directory = vim.fn.stdpath("config") .. "snippets",
    -- undotree configuration file
    -- • string
    nvim_undotree_dir = vim.fn.stdpath("cache") .. "undotree",
}

-- database link configuration
M.database_config = {
    {
        name = "dev",
        url = "mysql://nrnn@192.168.0.120/db1",
    },
    {
        name = "local",
        url = "mysql://root@localhost:3306/test",
    },
}

return M
