-- https://github.com/mfussenegger/nvim-dap

-- WARN: dap 手动下载调试器
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

-- local dap = require("dap")
--
-- -- 设置断点样式
-- vim.fn.sign_define("DapBreakpoint", {text = "⊚", texthl = "TodoFgFIX", linehl = "", numhl = ""})
--
-- -- 加载调试器配置
-- local dap_config = {
--     python = require("dap.python"),
--     -- go = require("dap.go")
-- }
--
--
-- -- 设置调试器配置
-- for dap_name, dap_options in pairs(dap_config) do
--     dap.adapters[dap_name] = dap_options.adapters
--     dap.configurations[dap_name] = dap_options.configurations
-- end

-- https://github.com/mfussenegger/nvim-dap

-- Dap download the debugger manually
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

local mapping = require("core.keybinds")


local function load_dap_config()
    -- Load adapter configuration file
    local dubug_adapter_config = {
        -- go = require("configs.dap.go"),
        python = require("configs.dap.python"),
        -- dotnet = require("configs.dap.dotnet"),
    }
end


local ok, m = pcall(require, "dap")
if not ok then
    return
end

load_dap_config()

for _, dap_config in pairs(M.dubug_adapter_config) do
    dap.adapters = vim.tbl_deep_extend("force", M.dap.adapters, dap_config.adapters)
    dap.configurations = vim.tbl_deep_extend("force", M.dap.configurations, dap_config.configurations)
end

mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>db",
        rhs = function()
            require("dap").toggle_breakpoint()
        end,
        options = { silent = true },
        description = "Mark or delete breakpoints",
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

