-- https://github.com/ethanholz/nvim-lastplace
local status_ok, nvim_lastposition = pcall(require, "nvim-lastplace")
if not status_ok then
  vim.notify("nvim_lastposition not found!")
	return
end

nvim_lastposition.setup({
    -- 不记录光标位置的buffer类型
    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
    -- 不记录光标位置的文件类型
    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
    lastplace_open_folds = true
})
