-- https://github.com/kyazdani42/nvim-tree.lua
-- 默认按键
-- o     ：打开目录或文件
-- a     ：新增目录或文件
-- r     ：重命名目录或文件
-- x     ：剪切目录或文件
-- c     ：复制目录或文件
-- d     ：删除目录或文件
-- y     ：复制目录或文件名称
-- Y     ：复制目录或文件相对路径
-- gy    ：复制目录或文件绝对路径
-- p     ：粘贴目录或文件
-- s     ：使用系统默认程序打开目录或文件
-- <Tab> ：将文件添加到缓冲区，但不移动光标
-- <C-v> ：垂直分屏打开文件
-- <C-x> ：水平分屏打开文件
-- <C-]> ：进入光标下的目录
-- <C-r> ：重命名目录或文件，删除已有目录名称
-- -     ：返回上层目录
-- I     ：切换隐藏文件/目录的可见性
-- H     ：切换点文件的可见性
-- R     ：刷新资源管理器
-- 另外，文件资源管理器操作和操作文档方式一致，可按 / ? 进行搜索

-- 目录后加上反斜杠 /
vim.g.nvim_tree_add_trailing = 1

vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 0


local mapping = require('core.mappings')
local icons = require("common.icons")

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    vim.notify("nvim-tree not found!")
    return
end

nvim_tree.setup({
    -- Disable netrw
    disable_netrw = false,
    -- Hijack the netrw window
    hijack_netrw = false,
    -- Keeps the cursor on the first letter of the filename when moving in the tree.
    hijack_cursor = true,
    -- Refresh tree when changing root
    update_cwd = true,
    -- Ignored file types
    ignore_ft_on_setup = { "dashboard" },
    -- Auto-reload tree (BufEnter event)
    reload_on_bufenter = true,
    -- Update the focused file on `BufEnter`, un-collapses the folders recursively
    -- until it finds the file.
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
    view = {
        side = "left",
        width = 30,
        hide_root_folder = false,
        signcolumn = "yes",
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info,
            warning = icons.diagnostics.Warn,
            error = icons.diagnostics.Error,
        },
    },
    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = true,
            restrict_above_cwd = false,
        },
        open_file = {
            resize_window = true,
            window_picker = {
                enable = true,
            },
        },
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    filters = {
        dotfiles = false,
        custom = { "node_modules", "\\.cache", "__pycache__" },
        exclude = {},
    },
    renderer = {
        add_trailing = true,
        highlight_git = true,
        highlight_opened_files = "none",
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★ ",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
})

mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>1",
        rhs = "<cmd>NvimTreeToggle<cr>",
        options = { silent = true },
        description = "Open File Explorer",
    },
    {
        mode = { "n" },
        lhs = "<leader>fc",
        rhs = "<cmd>NvimTreeFindFile<cr>",
        options = { silent = true },
        description = "Find the current file and open it in file explorer",
    },
})



-- with relative path
require "nvim-tree.events".on_file_created(function(file) vim.cmd("edit " .. file.fname) end)
-- with absolute path
-- require"nvim-tree.events".on_file_created(function(file) vim.cmd("edit "..vim.fn.fnamemodify(file.fname, ":p")) end)

-- auto close feature
vim.cmd(
[[
    autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]]
)
