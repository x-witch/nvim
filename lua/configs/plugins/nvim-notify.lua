-- https://github.com/rcarriga/nvim-notify

local status_ok, notify =  pcall(require, "notify")
if not status_ok then
  vim.notify("notify module not found!")
  return
end

local mapping = require('core.keybinds')

vim.notify = notify
notify.setup({
  -- Animation style (see below for details)
  stages = "fade_in_slide_out",

  -- Function called when a new window is opened, use for changing win settings/config
  on_open = nil,

  -- Function called when a window is closed
  on_close = nil,

  -- Render function for notifications. See notify-render()
  render = "default",

  -- Default timeout for notifications
  timeout = 5000,

  -- Max number of columns for messages
  max_width = nil,
  -- Max number of lines for a message
  max_height = nil,

  -- For stages that change opacity this is treated as the highlight behind the window
  -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
  background_colour = "Normal",

  -- Minimum width for notification windows
  minimum_width = 50,

  -- Icons for the different levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})

mapping.register({
    {
    mode = { "n" },
    lhs = "<leader>fn",
    rhs = "<cmd>lua require('telescope').extensions.notify.notify()<CR>",
    options = { silent = true },
    description = "nvim-notify 显示历史弹窗记录（需安装 telescope 插件）"
    },
})
