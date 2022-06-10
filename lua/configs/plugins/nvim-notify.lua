-- https://github.com/rcarriga/nvim-notify

local status_ok, notify =  pcall(require, "notify")
if not status_ok then
  vim.notify("notify module not found!")
  return
end
local icons = require("utility.icons")
local mapping = require('core.keybinds')

-- Define message warnings to ignore, usually from the LSP server
local ignore_message = {
    "exit code",
    "Invalid buffer",
    "textDocument/documentSymbol is not supported",
    "client has shut down after sending the message",
}

local notify_options = {
    -- animation style
    -- • fade_in_slide_out
    -- • fade
    -- • slide
    -- • static
    -- Under a transparent background, only static will ensure normal display effect
    stages = "static",
    -- default: 5000
    timeout = 3000,
    -- default: 30
    fps = 120,
    icons = {
        ERROR = icons.diagnostics.Error,
        WARN = icons.diagnostics.Warn,
        INFO = icons.diagnostics.Hint,
        DEBUG = " ",
        TRACE = "✎ ",
    },
}
notify.setup(notify_options)

vim.notify = setmetatable({}, {
    __call = function(self, msg, ...)
        for _, v in ipairs(ignore_message) do
            if msg:match(v) then
                return
            end
        end
        return notify(msg, ...)
    end,
    __index = notify,
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
