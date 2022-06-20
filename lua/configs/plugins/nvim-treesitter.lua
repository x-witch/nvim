-- https://github.com/nvim-treesitter/nvim-treesitter
-- https://github.com/p00f/nvim-ts-rainbow
local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    vim.notify("treesitter not found!")
    return
end

treesitter.setup({
    -- 安装的高亮支持来源，安装language parser,:TSInstallInfo查看
    ensure_installed = {  "vim", "lua", "python", "json", },
    ignore_install = { "" },
    sync_install = false,
    -- 高亮相关
    highlight = {
        -- 启用高亮支持
        enable = true,
        -- 使用 treesitter 高亮而不是 neovim 内置的高亮
        additional_vim_regex_highlighting = false,
        -- use_languagetree = true,
    },
    -- 根据当前上下文定义文件类型，由 nvim-ts-context-commentstring 插件提供
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
            -- Languages that have a single comment style
            typescript = "// %s",
            css = "/* %s */",
            scss = "/* %s */",
            html = "<!-- %s -->",
            svelte = "<!-- %s -->",
            vue = "<!-- %s -->",
            json = "",
        },
    },
    -- 范围选择
    incremental_selection = {
        enable = false,
        keymaps = {
            -- 初始化选择
            init_selection = "<CR>",
            -- 递增
            node_incremental = "<CR>",
            -- 递减
            node_decremental = "<BS>",
            -- 选择一个范围
            scope_incremental = "<TAB>"
        }
    },
    -- 缩进，关闭
    indent = {
        enable = true,
        disable = {}
    },
    -- 彩虹括号，由 nvim-ts-rainbow 插件提供
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000,
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    autotag = { enable = true },
    -- matchup plugin
    -- https://github.com/andymass/vim-matchup
    matchup = {
        enable = false, -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
        -- [options]
    },
    -- autopairs plugin
    autopairs = {
        enable = true,
    },
})
