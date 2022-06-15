-- 加载缓存优化 ./cache/nvim/luacache_chunks文件
local present, impatient = pcall(require, "impatient")

if present then
    impatient.enable_profile()
end

-- Enable Lua's ftplugin
vim.g.do_filetype_lua = 1
-- Do not disable ftplugin
vim.g.did_load_filetypes = 0

require("core.settings")
require("core.keybinds")
require("core.plugins")
require("core.utils")
require("configs.plugins")
require("core.options")
require("core.themes")

