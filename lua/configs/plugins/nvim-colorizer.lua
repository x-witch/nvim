-- https://github.com/norcalli/nvim-colorizer.lua
local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  vim.notify("colorizer not found!")
  return
end

local opts = {
    css = true,
}

colorizer.setup({
    "*",
    css = opts,
    javascript = opts,
    typescript = opts,
    vue = opts,
})

vim.cmd("ColorizerReloadAllBuffers")

