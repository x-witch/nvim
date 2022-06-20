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


local dap_status_ok, dap = pcall(require, 'dap')
if not dap_status_ok then
    vim.notify('dap not found')
    return
end

local api = vim.api
local fn = vim.fn

local icons_signs = require('utility.icons').signs
local mapping = require("core.keybinds")


----------------------------------------------------------------------
--                              设置断点样式icons                               --
----------------------------------------------------------------------
local dap_breakpoint = {
    error = {
        text = icons_signs.debug_breakpoint_error,
        texthl = "LspDiagnosticsSignError",
        linehl = "",
        numhl = "",
    },
    rejected = {
        text = icons_signs.debug_breakpoint_reject,
        texthl = "LspDiagnosticsSignHint",
        linehl = "",
        numhl = "",
    },
    stopped = {
        text = icons_signs.debug_breakpoint_stop,
        texthl = "LspDiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "LspDiagnosticsSignInformation",
    },
}
fn.sign_define("DapBreakpoint", dap_breakpoint.error)
fn.sign_define("DapStopped", dap_breakpoint.stopped)
fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

----------------------------------------------------------------------
--                            ui config                             --
----------------------------------------------------------------------
local vir_status_ok, _ = pcall(require, 'nvim-dap-virtual-text')
local dapui_status_ok, dapui = pcall(require, 'dapui')

local debug_open = function()
    if dapui_status_ok then
        dapui.open()
    end
    if vir_status_ok then
        api.nvim_command('DapVirtualTextEnable')
    end
end
local debug_close = function()
    dap.repl.close()
    if dapui_status_ok then
        dapui.close()
    end
    if vir_status_ok then
        api.nvim_command('DapVirtualTextDisable')
    end
end
dap.defaults.fallback.terminal_win_cmd = '30vsplit new' -- this will be overrided by dapui
dap.set_log_level('DEBUG')

local close_terminal = function()
    local bufnr = fn.bufnr('[dap-terminal] Launch File')
    if bufnr ~= -1 then
        api.nvim_buf_delete(bufnr, { force = true })
    end
end

----------------------------------------------------------------------
--                              events                              --
----------------------------------------------------------------------
-- https://github.com/mfussenegger/nvim-dap/wiki/Cookbook

local keymap_restore = {}

dap.listeners.after['event_initialized']['me'] = function()
    debug_open()
    for _, buf in pairs(api.nvim_list_bufs()) do
        local keymaps = api.nvim_buf_get_keymap(buf, 'n')
        for _, keymap in pairs(keymaps) do
            if keymap.lhs == "K" then
                table.insert(keymap_restore, keymap)
                api.nvim_buf_del_keymap(buf, 'n', 'K')
            end
        end
        api.nvim_buf_set_keymap(buf, 'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
    end
end

dap.listeners.after['event_terminated']['me'] = function()
    for _, keymap in pairs(keymap_restore) do
        api.nvim_buf_set_keymap(
            keymap.buffer,
            keymap.mode,
            keymap.lhs,
            keymap.rhs,
            { silent = keymap.silent == 1 }
        )
    end
    keymap_restore = {}
    debug_close()
    close_terminal()
end

dap.listeners.before['event_exited']['me'] = function()
    debug_close()
    close_terminal()
end

dap.listeners.before['disconnect']['me'] = function()
    debug_close()
    close_terminal()
end

dap.listeners.after['disconnect']['me'] = function()
    close_repl()
end


----------------------------------------------------------------------
--                         adapters config                          --
----------------------------------------------------------------------

local dap_config = {
    python = require("configs.dap.python"),
    -- go = require("configs.dap.go")
}

-- 设置调试器
for dap_name, dap_options in pairs(dap_config) do
    dap.adapters[dap_name] = dap_options.adapters
    dap.configurations[dap_name] = dap_options.configurations
end


----------------------------------------------------------------------
--                              keymap                              --
----------------------------------------------------------------------
mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>db",
        rhs = function()
            require("dap").toggle_breakpoint()
        end,
        options = { silent = true },
        description = "打断点或删除断点",
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
            require("dapui").eval(vim.fn.input("Enter debug expression: "))
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
        description = "开启调试或到下一个断点处",
    },
    {
        mode = { "n" },
        lhs = "<F6>",
        rhs = function()
            require("dap").step_into()
        end,
        options = { silent = true },
        description = "单步进入执行（会进入函数内部，有回溯阶段）",
    },
    {
        mode = { "n" },
        lhs = "<F7>",
        rhs = function()
            ---@diagnostic disable-next-line: missing-parameter
            require("dap").step_over()
        end,
        options = { silent = true },
        description = "单步跳过执行（不进入函数内部，无回溯阶段）",
    },
    {
        mode = { "n" },
        lhs = "<F8>",
        rhs = function()
            require("dap").step_out()
        end,
        options = { silent = true },
        description = "步出当前函数",
    },
    {
        mode = { "n" },
        lhs = "<F9>",
        rhs = function()
            require("dap").run_last()
        end,
        options = { silent = true },
        description = "重启调试",
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
    -- {
    --     mode = { "n" },
    --     lhs = "<F10>",
    --     rhs = "<cmd>lua require'dap'.close()<CR><cmd>lua require'dap.repl'.close()<CR><cmd>lua require'dapui'.close()<CR><cmd>DapVirtualTextForceRefresh<CR>",
    --     options = { silent = true },
    --     description = "退出调试（关闭调试，关闭 repl，关闭 ui，清除内联文本）",
    -- },
})
