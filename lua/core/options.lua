local _M = {}

_M.colorscheme = {
    light = false,
    theme = 'catppuccin'
}

-- 用户自定义选项
-- _M.python_path = "/usr/bin/python3"
-- -- lint 配置文件路径
-- _M.lint_config_dir = vim.fn.stdpath("config") .. "/lint"
-- -- 代码片段存储路径
-- _M.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
-- -- undotree 缓存存放路径
-- _M.undotree_dir = vim.fn.stdpath("cache") .. "/undotree"

vim.g.python_path = "/usr/bin/python3"
-- -- lint 配置文件路径
vim.g.lint_config_dir = vim.fn.stdpath("config") .. "/lint"
-- -- 代码片段存储路径
vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
-- -- undotree 缓存存放路径
vim.g.undotree_dir = vim.fn.stdpath("cache") .. "/undotree"

return _M
