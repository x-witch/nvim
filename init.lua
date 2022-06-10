-- 加载缓存优化 ./cache/nvim/luacache_chunks文件
local present, impatient = pcall(require, "impatient")

if present then
    impatient.enable_profile()
end

require("core.settings")
require("core.keybinds")
require("core.plugins")
require("core.utils")
require("configs.plugins")


