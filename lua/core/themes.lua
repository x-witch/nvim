
----------------------------------------------------------------------
--                           colorscheme                            --
----------------------------------------------------------------------
local colorscheme = require('core.options').colorscheme
if colorscheme.light then
    vim.cmd[[set background=light]]
else
    vim.cmd[[set background=dark]]
end
local status_ok = pcall(vim.cmd, 'colorscheme ' .. colorscheme.theme)
if not status_ok then
    vim.notify('The theme "' .. colorscheme.theme .. '" not found')
end
