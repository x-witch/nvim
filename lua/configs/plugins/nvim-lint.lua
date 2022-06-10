-- https://github.com/mfussenegger/nvim-lint
-- WARN: nvim-lint 手动下载诊断工具，确保该诊断工具能被全局调用
-- pip3 install pylint

local status_ok, lint = pcall(require, "lint")
if not status_ok then
	return
end

lint.linters_by_ft = {
  python = { "pylint" }
  -- javascript = {"eslint"},
  -- typescript = {"eslint"},
  -- go = {"golangcilint"}
}
-- 配置 pylint
lint.linters.pylint.args = {
  "-f",
  "json",
  "--rcfile=~/.config/nvim/lint/pylint.conf"
}
-- 何时触发检测：
-- BufEnter    ： 载入 Buf 后
-- BufWritePost： 写入文件后
-- 由于搭配了 AutoSave，所以其他的事件就不用加了
-- vim.cmd([[
-- au BufEnter * lua require('lint').try_lint()
-- au BufWritePost * lua require('lint').try_lint()
-- ]])

vim.api.nvim_create_autocmd(
    {"InsertLeave", "TextChanged", "BufNew"},
    {
        pattern = "*",
        callback = function()
            require("lint").try_lint()
        end
    }
)
