-- WARN: telescope 手动安装依赖 fd 和 ripgrep 和 fzf
-- https://github.com/sharkdp/fd
-- https://github.com/BurntSushi/ripgrep
-- NOTE: install ripgrep for live_grep picker

-- ====for live_grep raw====:
-- for rp usage: reference: https://segmentfault.com/a/1190000016170184
-- -i ignore case
-- -s 大小写敏感
-- -w match word
-- -e 正则表达式匹配
-- -v 反转匹配
-- -g 通配符文件或文件夹，可以用!来取反
-- -F fixed-string 原意字符串，类似python的 r'xxx'

-- examples:
-- command	Description
-- rg image utils.py	Search in a single file utils.py
-- rg image src/	Search in dir src/ recursively
-- rg image	Search image in current dir recursively
-- rg '^We' test.txt	Regex searching support (lines starting with We)
-- rg -i image	Search image and ignore case (case-insensitive search)
-- rg -s image	Smart case search
-- rg -F '(test)'	Search literally, i.e., without using regular expression
-- rg image -g '*.py'	File globing (search in certain files), can be used multiple times
-- rg image -g '!*.py'	Negative file globing (do not search in certain files)
-- rg image --type py or rg image -tpy1	Search image in Python file
-- rg image -Tpy	Do not search image in Python file type
-- rg -l image	Only show files containing image (Do not show the lines)
-- rg --files-without-match image	Show files not containing image
-- rg -v image	Inverse search (search files not containing image)
-- rg -w image	Search complete word
-- rg --count	Show the number of matching lines in a file
-- rg --count-matches	Show the number of matchings in a file
-- rg neovim --stats	Show the searching stat (how many matches, how many files searched etc.)

-- ====for fzf search=====
-- Token	tch type	Description
-- sbtrkt	fuzzy-match	Items that match sbtrkt
-- 'wild	exact-match (quoted)	Items that include wild
-- ^music	prefix-exact-match	Items that start with music
-- .mp3$	suffix-exact-match	Items that end with .mp3
-- !fire	inverse-exact-match	Items that do not include fire
-- !^music	inverse-prefix-exact-match	Items that do not start with music
-- !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    vim.notify("telescope not found!")
    return
end

-- https://github.com/nvim-telescope/telescope.nvim

local mapping = require("core.mappings")

telescope.setup({
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = " ",
        multi_icon = " ",
        color_devicons = true,
        file_ignore_patterns = { "node_modules" },
        -- theme
        layout_strategy = "bottom_pane",
        -- config
        layout_config = {
            bottom_pane = {
                height = 15,
                preview_cutoff = 100,
                prompt_position = "bottom",
            },
        },
        pickers = {
            find_files = {
                hidden = true,
            },
            live_grep = {
                -- don't include the filename in the search results
                only_sort_text = true,
            },
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        use_less = true,
        set_env = { ["COLORTER"] = "truecolor" },  -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    },
    extensions_list = { "themes", "terms" },
    pickers = {
        buffers = {
            mappings = {
                i = {
                    ["<c-d>"] = "delete_buffer",
                },
                n = {
                    ["dd"] = "delete_buffer",
                },
            },
        },
    },
})


mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>ff",
        rhs = function()
            require("telescope.builtin").find_files()
        end,
        options = { silent = true },
        description = "Find files in the current workspace",
    },
    {
        mode = { "n" },
        lhs = "<leader>fg",
        rhs = function()
            require("telescope.builtin").live_grep()
        end,
        options = { silent = true },
        description = "Find string in the current workspace",
    },
    {
        mode = { "n" },
        lhs = "<leader>fo",
        rhs = function()
            require("telescope.builtin").oldfiles()
        end,
        options = { silent = true },
        description = "Find telescope history",
    },
    {
        mode = { "n" },
        lhs = "<leader>fh",
        rhs = function()
            require("telescope.builtin").resume()
        end,
        options = { silent = true },
        description = "Find last lookup",
    },
    {
        mode = { "n" },
        lhs = "<leader>ft",
        rhs = function()
            require("telescope.builtin").help_tags()
        end,
        options = { silent = true },
        description = "Find all help document tags",
    },
    {
        mode = { "n" },
        lhs = "<leader>fm",
        rhs = function()
            require("telescope.builtin").marks()
        end,
        options = { silent = true },
        description = "Find marks in the current workspace",
    },
    {
        mode = { "n" },
        lhs = "<leader>fi",
        rhs = function()
            require("telescope.builtin").highlights()
        end,
        options = { silent = true },
        description = "Find all neovim highlights",
    },
    {
        mode = { "n" },
        lhs = "<leader>fb",
        rhs = function()
            require("telescope.builtin").buffers()
        end,
        options = { silent = true },
        description = "Find all buffers",
    },
    {
        mode = { "n" },
        lhs = "<leader>f/",
        rhs = function()
            require("telescope.builtin").search_history()
        end,
        options = { silent = true },
        description = "Find all search history",
    },
    {
        mode = { "n" },
        lhs = "<leader>f:",
        rhs = function()
            require("telescope.builtin").command_history()
        end,
        options = { silent = true },
        description = "Find all command history",
    },
})

