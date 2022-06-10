local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify("正在安装Pakcer.nvim，请稍后...")
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    -- "https://gitcode.net/mirrors/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
  -- https://github.com/wbthomason/packer.nvim/issues/750
  local rtp_addition = vim.fn.stdpath("data") .. "/site/pack/*/start/*"
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. "," .. vim.o.runtimepath
  end
  vim.notify("Pakcer.nvim 安装完毕")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file

local packer_user_config = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "plugins.lua" },
  callback = function()
    vim.cmd("source <afile> | PackerSync")
  end,
  group = packer_user_config,
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

--  useage
-- use {
--   "myusername/example",        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use. Supports "*" for "latest tag"
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When
--   requiring a string which matches one of these patterns, the plugin will be loaded.
-- }

-- Install your plugins here
return packer.startup(function(use)
    --[[
	=====================================
	  ------------- basic -------------
	=====================================
	--]]
    use("wbthomason/packer.nvim")
    use("lewis6991/impatient.nvim") -- 插件缓存
    use("nathom/filetype.nvim")
    use("kyazdani42/nvim-web-devicons") -- icons
    use("rcarriga/nvim-notify") --通知
    use("nvim-lua/popup.nvim") -- 弹窗
    use("nvim-lua/plenary.nvim") -- lua开发模块
    -- 中文文档
    use({
        "yianwillis/vimcdoc",
        event = { "BufRead", "BufNewFile" },
    })
    use({
        "lewis6991/gitsigns.nvim",
        event = { "BufRead", "BufNewFile" },
    })

    --[[
	=====================================
	 ------------- Theme ---------------
	=====================================
	--]]
    use({ "askfiy/catppuccin", })
    -- 浅色主题
    use({ "sainnhe/everforest" })
    use("goolord/alpha-nvim")

    --[[
	=====================================
	 ---------- Core function ----------
	=====================================
	--]]
    use("nvim-lualine/lualine.nvim") -- 底部状态栏
    -- 目录大纲
    use({
        "kyazdani42/nvim-tree.lua",
        tag = 'nightly',
        after = { "nvim-web-devicons" }
    })
    use({
        "akinsho/bufferline.nvim",
        after = { "nvim-web-devicons" }
    })
    use("famiu/bufdelete.nvim")
    use({
        "folke/which-key.nvim",
        event = { "BufRead", "BufNewFile" },
    })
    use({
        "mbbill/undotree",
        event = { "BufRead", "BufNewFile" },
    })

    --[[
	=====================================
	 ----- language server protocol ----
	=====================================
	--]]

    use({
        "neovim/nvim-lspconfig",
        after = { "impatient.nvim" },
    })
    use({
        "hrsh7th/cmp-nvim-lsp",
        after = { "nvim-lspconfig" },
    })
    use({
        "stevearc/aerial.nvim",
        after = { "nvim-lspconfig" },
    })
    use({
        "jose-elias-alvarez/null-ls.nvim",
        after = { "nvim-lspconfig" },
    })
    use({
        "williamboman/nvim-lsp-installer",
        after = { "nvim-lspconfig", "null-ls.nvim" },
    })
    use({
        "j-hui/fidget.nvim",
        after = { "nvim-lsp-installer" },
    })
    use({
        "kosayoda/nvim-lightbulb",
        after = { "nvim-lspconfig" },
    })
    use({
        "ray-x/lsp_signature.nvim"
    })
    use({"mfussenegger/nvim-lint"})
    
    --[[
	=====================================
	 --------- Code Completion ---------
	=====================================
	--]]
    use({
        "hrsh7th/nvim-cmp"
    })
    use({
        "rafamadriz/friendly-snippets",
        event = { "InsertEnter", "CmdlineEnter" },
    })
    use({
        "hrsh7th/vim-vsnip",
        after = { "friendly-snippets" },
    })
    use({
        "hrsh7th/cmp-vsnip",
        after = { "nvim-cmp" },
    })
    use({
        "hrsh7th/cmp-buffer",
        after = { "nvim-cmp" },
    })
    use({
        "hrsh7th/cmp-path",
        after = { "nvim-cmp" },
    })
    use({
        "hrsh7th/cmp-cmdline",
        after = { "nvim-cmp" },
    })
    use({
        "kristijanhusak/vim-dadbod-completion",
        after = { "nvim-cmp" },
    })
    use({
        "tzachar/cmp-tabnine",
        disable = false,
        run = "./install.sh",
        after = { "nvim-cmp" },
    })
    use({
        "github/copilot.vim",
        disable = false,
        event = { "InsertEnter" }
    })

    --[[
	=====================================
	 ----- debug adapter protocol ------
	=====================================
	--]]
    use({
        "mfussenegger/nvim-dap",
        module = "dap",
    })
    use({
        "theHamsta/nvim-dap-virtual-text",
        after = { "nvim-dap" },
    })
    use({
        "rcarriga/nvim-dap-ui",
        after = { "nvim-dap" },
    })

    --[[
	=====================================
	 ------- Database connection -------
	=====================================
	--]]
    use({
        "tpope/vim-dadbod",
        fn = { "db#resolve" },
    })
    use({
        "kristijanhusak/vim-dadbod-ui",
        cmd = "DBUIToggle",
    })

    --[[
	=====================================
	 ----------- Code Editor -----------
	=====================================
	--]]
    use({
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
    })
    use({
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
    })
    use({
        "RRethy/vim-illuminate",
        event = { "BufReadPre", "BufNewFile" },
    })
    use({
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPre", "BufNewFile" },
    })
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
    })
    use({
        "lewis6991/spellsitter.nvim",
        after = { "nvim-treesitter" },
    })
    use({
        "p00f/nvim-ts-rainbow",
        after = { "nvim-treesitter" },
    })
    use({
        "windwp/nvim-ts-autotag",
        after = { "nvim-treesitter" },
    })
    use({
        "JoosepAlviste/nvim-ts-context-commentstring",
        after = { "nvim-treesitter" },
    })
    use({
        "numToStr/Comment.nvim",
        after = { "nvim-ts-context-commentstring" },
    })
    use({ -- 点模式增强
        "tpope/vim-repeat",
        fn = "repeat#set",
    })
    use({
        "ur4ltz/surround.nvim",
        event = { "BufRead", "BufNewFile" },
    })
    use({
        "AndrewRadev/switch.vim",
        cmd = { "Switch" },
        fn = { "switch#Switch" },
    })
    use({
        "Vimjas/vim-python-pep8-indent",
        ft = "py",
        event = { "InsertEnter" },
    })
    use({
        "mattn/emmet-vim",
        ft = { "html", "javascript", "typescript", "vue", "xml", "jsx" },
    })

    --[[
	=====================================
	 ----------- Fuzzy lookup ----------
	=====================================
	--]]
    use({
        "nvim-telescope/telescope.nvim",
        module = "telescope",
    })
    use({
        "tami5/sqlite.lua",
        after = { "impatient.nvim" },
    })
    use({
        "AckslD/nvim-neoclip.lua",
        after = { "sqlite.lua" },
    })
    use({
        "nvim-pack/nvim-spectre",
        module = "spectre",
    })

     --[[
	=====================================
	 ------ Documentation editing ------
	=====================================
	--]]
    -- use({
    --     "phaazon/hop.nvim",
    --     module = "hop",
    --     cmd = { "HopWord", "HopLine", "HopChar1", "HopChar1CurrentLine" },
    -- })
    use({
        "kevinhwang91/nvim-hlslens",
        module = "hlslens",
        event = { "CmdlineEnter" },
    })
    use({
        "davidgranstrom/nvim-markdown-preview",
        ft = { "markdown" },
    })
    use({
        "mg979/vim-visual-multi",
        fn = { "vm#commands#add_cursor_up", "vm#commands#add_cursor_down" },
    })
    -- use({
    --     "jbyuki/venn.nvim",
    --     module = "venn",
    -- })
    use({
        "kristijanhusak/vim-carbon-now-sh",
        cmd = { "CarbonNowSh" },
    })

    --[[
	=====================================
	 ---------- Other function ---------
	=====================================
	--]]
    use({
        "dstein64/vim-startuptime",
        cmd = { "StartupTime" },
    })
    use({
        "ethanholz/nvim-lastplace",
        event = { "BufRead" },
    })
    use({
        "dstein64/nvim-scrollview",
        event = { "BufRead", "BufNewFile" },
    })
    use({
        "akinsho/toggleterm.nvim",
        module = "toggleterm",
    })
    -- use({
    --     "uga-rosa/translate.nvim",
    --     cmd = { "Translate" },
    -- })
    use({
        "jghauser/mkdir.nvim",
        event = "CmdlineEnter",
    })
    use({
         "michaelb/sniprun",
        run = "bash ./install.sh",
    })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
