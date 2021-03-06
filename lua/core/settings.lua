-- There are some settings, which are automatically configured in neovim
-- you can view it with :h vim-differences

local settings = {
    -- g = {
    --     -- Enable Lua's ftplugin
    --     do_filetype_lua = 1,
    --     -- Do not disable ftplugin
    --     did_load_filetypes = 0,
    -- },
    opt = {
        -- Turn on syntax highlighting
        syntax = "enable",
        -- Set background mode
        background = "dark",

        -- Set the character encoding used internally by nvim
        encoding = "utf-8",
        -- Set the character encoding of the file where the current buffer is located
        fileencoding = "utf-8",
        -- Allow plugin loading of file types
        filetype = "plugin",
        -- Whether to create a backup file
        backup = false,
        -- Whether to create a swap file
        swapfile = false,
        -- Whether to create backups when writing files
        writebackup = false,
        -- Set completion options
        -- completeopt =  "menu, menuone, noselect",
        -- Set the width of the symbol column, if not set, it will cause an exception when displaying the icon
        signcolumn = "yes:1",
        -- Allow the window to display the edited filename
        title = true,
        -- Allows to display the current vim mode (no need)
        showmode = false,
        -- Set the height of the completion menu
        pumheight = 10,
        -- Speed up response time
        updatetime = 100,
        -- Set timeout
        timeoutlen = 500,
        -- Show command line
        showcmd = true,
        -- Allow switching from unsaved buffers
        hidden = true,
        -- Terminal supports more colors
        termguicolors = true,
        -- Highlight the current line
        cursorline = true,

        -- Allow absolute line numbers
        number = true,
        -- Allow relative line numbers
        relativenumber = true,
        -- Display the row and column numbers of the cursor position (off, don't need it)
        ruler = false,
        -- Set the width of the number column, default is 4
        numberwidth = 2,
        -- Set how many lines are always displayed on the upper and lower sides of the cursor
        scrolloff = 10,
        -- Set how many columns are always displayed to the left and right of the cursor, requires wrap = true.
        -- wrap = true,
        sidescrolloff = 5,
        -- Allow the use of the mouse
        mouse = "a",
        -- Allow padding with special characters
        list = true,
        -- Highlight while searching
        incsearch = true,
        -- Allow search highlighting
        hlsearch = true,
        -- Allows to search the entire file repeatedly (continuation of the search after the last result will return to the first result)
        -- wrapscan = true,
        -- Allow matching symbols to be displayed (no need, there is a plugin for auto-completing parentheses)
        showmatch = false,
        -- Default is 5, set the duration of showmatch
        matchtime = 2,
        -- Turn on spell check
        -- spell = true,
        -- Set the language for spell checking
        -- spelllang = "en_us,cjk",
        -- Set completion in command mode to appear as a menu
        wildmenu = true,
        -- Set command line height
        cmdheight = 1,
        -- Ignore case when searching
        ignorecase = true,
        -- Intelligent case sensitivity when searching (if there is upper case, turn off case ignoring)
        smartcase = true,
        -- Open fold
        foldenable = true,
        -- Set the folding method
        foldmethod = "indent",
        -- Show collapsed hierarchy in symbol column
        foldcolumn = "0",
        -- Maximum folding level
        foldlevel = 100,
        -- Natural line breaks
        linebreak = true,
        -- Use the system clipboard
        clipboard = "unnamedplus",

        -- Automatically read files modified in other editors
        autoread = true,
        -- Auto-indent, press o on the current line, the new line is always aligned with the current line
        autoindent = true,
        -- Set smart indent
        smartindent = true,

        -- Set allowed word separators (chains with _ are allowed in words)
        iskeyword = "@,48-57,_,-,192-255",
        -- Set options for saving sessions
        sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,globals",
        -- Enable global status bar
        laststatus = 3,
        -- After turning on the global status bar, we should set a more obvious separator
        fillchars = "vert:???,horiz:???,verthoriz:???,horizup:???,horizdown:???,vertleft:???,vertright:???",
        completeopt = 'menuone,noselect,noinsert',

        -- listchars = 'space:???,tab:??? ,eol:??,nbsp:???,extends:??,precedes:??,trail:??' -- space:???
        -- listchars = 'tab:??? ,eol:??,nbsp:???,extends:??,precedes:??,trail:??' -- space:???
    },
    -- ????????????????????????
    disable_builtin_plugins = {
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'gzip',
        'zip',
        'zipPlugin',
        'tar',
        'tarPlugin',
        'getscript',
        'getscriptPlugin',
        'vimball',
        'vimballPlugin',
        '2html_plugin',
        'logipat',
        'rrhelper',
        'spellfile_plugin',
        'matchit',
        'matchparen',
        'man',
        'tutor_mode_plugin',
        'remote_plugins',
        'shada_plugin',
        'filetype',
    },
}

-- Reduce the display of <c-g>
vim.opt.shortmess:append("sI")
-- Allow h and l newlines
-- vim.opt.whichwrap:append("<>[]hl")
-- Remove auto-comments
vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }

for prefix, tbl in pairs(settings) do
    if prefix ~= "disable_builtin_plugins" then
        for key, value in pairs(tbl) do
            vim[prefix][key] = value
        end
    else
        for _, plugin in pairs(tbl) do
            vim.g["loaded_" .. plugin] = 1
        end
    end
end


if vim.bo.fileformat == "unix" then
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        pattern = { "*" },
        callback = function()
            local input_status = tonumber(vim.fn.system("fcitx5-remote"))
            if input_status == 2 then
                vim.fn.system("fcitx5-remote -c")
            end
        end,
    })
else
end
