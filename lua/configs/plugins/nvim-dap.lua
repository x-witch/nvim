-- https://github.com/mfussenegger/nvim-dap

-- WARN: dap 手动下载调试器
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

-- -- 设置断点样式
-- vim.fn.sign_define("DapBreakpoint", {text = "⊚", texthl = "TodoFgFIX", linehl = "", numhl = ""})
--
-- -- 加载调试器配置
-- local dap_config = {
--     python = require("dap.python"),
--     -- go = require("dap.go")
-- }
--
-- -- 设置调试器配置
-- for dap_name, dap_options in pairs(dap_config) do
--     dap.adapters[dap_name] = dap_options.adapters
--     dap.configurations[dap_name] = dap_options.configurations
-- end

local ok, dap = pcall(require, "dap")
if not ok then
    return
end
local dapui = require('dapui')
local dap_install = require("dap-install")

local mapping = require("core.keybinds")

require('utils').create_augroup({
    {
        event = 'FileType',
        opts = {
            pattern = 'dap-repl',
            callback = function() require('dap.ext.autocompl').attach() end
        }
    }
}, 'dap')

-- config_dapi_and_sign
dap_install.setup {
    installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
}

local dap_breakpoint = {
    error = {
        text = "🛑",
        texthl = "LspDiagnosticsSignError",
        linehl = "",
        numhl = "",
    },
    rejected = {
        text = "",
        texthl = "LspDiagnosticsSignHint",
        linehl = "",
        numhl = "",
    },
    stopped = {
        text = "⭐️",
        texthl = "LspDiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "LspDiagnosticsSignInformation",
    },
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

local debug_open = function()
    dapui.open()
    vim.api.nvim_command("DapVirtualTextEnable")
end
local debug_close = function()
    dap.repl.close()
    dapui.close()
    vim.api.nvim_command("DapVirtualTextDisable")
    -- vim.api.nvim_command("bdelete! term:")   -- close debug temrinal
end

dap.listeners.after.event_initialized["dapui_config"] = function()
    debug_open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    debug_close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    debug_close()
end
dap.listeners.before.disconnect["dapui_config"] = function()
    debug_close()
end

-- config_debuggers
-- TODO: wait dap-ui for fixing temrinal layout
-- the "30" of "30vsplit: doesn't work
dap.defaults.fallback.terminal_win_cmd = '30vsplit new' -- this will be overrided by dapui
dap.set_log_level("DEBUG")

-- load from json file
-- require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'cpp' } })
-- config per launage

require("configs.dap.go")
require("configs.dap.python")
require("configs.dap.lua")
-- require("user.dap.dap-cpp")
-- require("config.dap.python").setup()
-- require("config.dap.rust").setup()
-- require("config.dap.go").setup()

--[[
	=====================================
	 ------ DAP UI ------
	=====================================
	--]]
dapui.setup({
    icons = { expanded = '▾', collapsed = '▸' },
    mappings = {
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
    },
    expand_lines = vim.fn.has('nvim-0.7'),
    sidebar = {
        elements = {
            { id = 'scopes', size = 0.25, },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 00.25 },
        },
        size = 60,
        position = 'left',
    },
    tray = {
        elements = { 'repl', 'console' },
        size = 15,
        position = 'bottom',
    },
    floating = {
        max_height = nil,
        max_width = nil,
        border = 'single',
        mappings = {
            close = { 'q', '<Esc>' },
        },
    },
    windows = { indent = 1 },
    render = {
        max_type_length = nil,
    }
})

-- dap.listeners.after.event_initialized['dapui_config'] = function()
--     dapui.open()
-- end
-- dap.listeners.before.event_terminated['dapui_config'] = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited['dapui_config'] = function()
--     dapui.close()
-- end

--[[
	=====================================
	 ------ DAP Virtual Text ------
	=====================================
	--]]
require('nvim-dap-virtual-text').setup()

-- keymap
mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>du",
        rhs = "<cmd>lua require'dapui'.toggle()<CR>",
        options = { silent = true },
        description = "显示或隐藏调试界面",
    },
    {
        mode = { "n" },
        lhs = "<leader>db",
        rhs = function()
            require("dap").toggle_breakpoint()
        end,
        options = { silent = true },
        description = "rk or delete breakpoints",
    },
    {
        mode = { "n" },
        lhs = "<leader>de",
        rhs = function()
            local wins = vim.api.nvim_list_wins()
            for _, win_id in ipairs(wins) do
                local buf_id = vim.api.nvim_win_get_buf(win_id)
                local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")
                if ft == "dapui_hover" then
                    ---@diagnostic disable-next-line: missing-parameter
                    require("dapui").eval()
                    return
                end
            end
            -- require("dapui").eval(vim.fn.input("Enter debug expression: "))
        end,
        options = { silent = true },
        description = "Execute debug expressions",
    },
    {
        mode = { "n" },
        lhs = "<leader>dc",
        rhs = function()
            require("dap").clear_breakpoints()
        end,
        options = { silent = true },
        description = "Clear breakpoints in the current buffer",
    },
    {
        mode = { "n" },
        lhs = "<F5>",
        rhs = function()
            require("dap").continue()
        end,
        options = { silent = true },
        description = "Enable debugging or jump to the next breakpoint",
    },
    {
        mode = { "n" },
        lhs = "<F6>",
        rhs = function()
            require("dap").step_into()
        end,
        options = { silent = true },
        description = "Step into",
    },
    {
        mode = { "n" },
        lhs = "<F7>",
        rhs = function()
            ---@diagnostic disable-next-line: missing-parameter
            require("dap").step_over()
        end,
        options = { silent = true },
        description = "Step over",
    },
    {
        mode = { "n" },
        lhs = "<F8>",
        rhs = function()
            require("dap").step_out()
        end,
        options = { silent = true },
        description = "Step out",
    },
    {
        mode = { "n" },
        lhs = "<F9>",
        rhs = function()
            require("dap").run_last()
        end,
        options = { silent = true },
        description = "Rerun debug",
    },
    {
        mode = { "n" },
        lhs = "<F10>",
        rhs = function()
            require("dap").terminate()
        end,
        options = { silent = true },
        description = "Close debug",
    },
})
