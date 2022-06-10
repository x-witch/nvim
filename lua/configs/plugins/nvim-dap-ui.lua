-- https://github.com/rcarriga/nvim-dap-ui

local status_ok, dapui = pcall(require, 'dapui')
if not status_ok then
  vim.notify("dapui not found")
  return
end

local dap = require("dap")

local mapping = require("core.keybinds")

dapui.setup({
    sidebar = {
        -- Dapui windows on the right
        position = "right",
    },
})

-- Automatically start dapui when debugging starts
dap.listeners.after.event_initialized["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    dapui.open()
end
-- Automatically close dapui and repl windows when debugging is closed
dap.listeners.before.event_terminated["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    dapui.close()
    dap.repl.close()
end
-- Automatically close dapui and repl windows when debugging is closed
dap.listeners.before.event_exited["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    dapui.close()
    dap.repl.close()
end

mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>du",
        rhs = function()
            ---@diagnostic disable-next-line: missing-parameter
            require("dapui").toggle()
        end,
        options = { silent = true },
        description = "Toggle debug ui",
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
})

