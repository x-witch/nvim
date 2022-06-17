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
--                              icons                               --
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

-- dap.listeners.after.event_initialized["dapui_config"] = function()
--     debug_open()
-- end
-- dap.listeners.after.event_terminated["dapui_config"] = function()
--     debug_close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--     debug_close()
-- end
-- dap.listeners.before.disconnect["dapui_config"] = function()
--     debug_close()
-- end

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

-- dap.listeners.after['disconnect']['me'] = function()
--     close_repl()
-- end


----------------------------------------------------------------------
--                         adapters config                          --
----------------------------------------------------------------------
local debug_config = require('configs.dap.debugers').debug_servers
local debug_server_names = debug_config.names
local debug_server_config = debug_config.config

for k_name, v_name in pairs(debug_server_names) do
    if debug_server_config[k_name] ~= nil then
        dap.adapters[v_name] = debug_server_config[k_name]['adapter']
        dap.configurations[k_name] = debug_server_config[k_name]['config']
    end
end



-- load from json file
-- require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'cpp' } })
-- -- config per launage
--
-- require("configs.dap.go")
-- require("configs.dap.python")
-- require("configs.dap.lua")


----------------------------------------------------------------------
--                              keymap                              --
----------------------------------------------------------------------
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
