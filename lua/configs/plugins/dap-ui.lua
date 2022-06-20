-- https://github.com/rcarriga/nvim-dap-ui

local status_ok, dapui = pcall(require, 'dapui')
if not status_ok then
    vim.notify('nvim-dap-ui not found')
    return
end

local _, dap = pcall(require, 'dap')
local mapping = require('core.keybinds')

dapui.setup({
    icons = { expanded = '▾', collapsed = '▸' },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { 'l', 'o', '<2-LeftMouse>' },
        open = { 'O', '<CR>' },
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
    },
    expand_lines = vim.fn.has("nvim-0.7"),
    layouts = {
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "breakpoints",
                "stacks",
                "watches",
            },
            size = 40,
            position = "left",
        },
        sidebar = {
            -- You can change the order of elements in the sidebar
            elements = {
                -- Provide as ID strings or tables with 'id' and 'size' keys
                { id = 'breakpoints', size = 0.15 },
                { id = 'watches', size = 0.15 },
                { id = 'stacks', size = 0.35 },
                { id = 'scopes', size = 0.35 }, -- Can be float or integer > 1
            },
            size = 40,
            position = 'left', -- Can be 'left', 'right', 'top', 'bottom'
        },
        tray = {
            elements = { 'repl' },
            size = 15,
            position = 'bottom', -- Can be 'left', 'right', 'top', 'bottom'
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            border = 'single', -- Border style. Can be 'single', 'double' or 'rounded'
            mappings = {
                close = { 'q', '<Esc>' },
            },
        },
        windows = { indent = 1 },
    }
})

-- --事件监听
-- -- 如果开启或关闭调试，则自动打开或关闭调试界面
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--     dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--     dapui.close()
--     dap.repl.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--     dapui.close()
--     dap.repl.close()
-- end

-- 显示或隐藏调试界面
mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>du",
        rhs = "<cmd>lua require'dapui'.toggle()<CR>",
        options = { silent = true },
        description = "显示或隐藏调试界面",
    },
})
