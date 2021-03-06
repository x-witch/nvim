-- https://github.com/lukas-reineke/indent-blankline.nvim

local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	return
end

-- vim.g.indentLine_enabled = 1
-- vim.g.indent_blankline_char = "│"
-- vim.g.indent_blankline_char = "▎"
-- vim.g.indent_blankline_char = "▏"
vim.opt.termguicolors = true
vim.opt.list = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

indent_blankline.setup({
    char = "▏",
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
    -- show_end_of_line = true,
    -- show_trailing_blankline_indent = false,
    -- show_first_indent_level = true,
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
        "startify",
        "dashboard",
        "dotooagenda",
        "log",
        "fugitive",
        "gitcommit",
        "packer",
        "vimwiki",
        "markdown",
        "txt",
        "vista",
        "help",
        "NvimTree",
        "peekaboo",
        "git",
        "TelescopePrompt",
        "undotree",
        "flutterToolsOutline",
        -- "", -- for all buffers without a file type
    },
    context_patterns = {
        "class",
        "function",
        "method",
        "block",
        "list_literal",
        "selector",
        "^if",
        "^table",
        "if_statement",
        "while",
        "for",
    },
})

-- vim.cmd("autocmd CursorMoved * IndentBlanklineRefresh")
