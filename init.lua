-- 加载缓存优化 ./cache/nvim/luacache_chunks文件
local present, impatient = pcall(require, "impatient")

if present then
    impatient.enable_profile()
end

require("core.options")
require("core.mappings")
require("core.plugins")
require("core.autocmds")
require("core.default_config")
require("core.utils")
require("configs.plugins")


