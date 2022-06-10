-- https://github.com/nvim-pack/nvim-spectre
-- WARN: spectre 手动安装依赖项 sed 和 ripgrep
-- sed 命令（自行安装，如果已有则忽略）
-- ripgrep： https://github.com/BurntSushi/ripgrep
local status_ok, spectre = pcall(require, "spectre")
if not status_ok then
  vim.notify("spectre not found!")
	return
end

local mapping = require("core.keybinds")

spectre.setup()

mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>rp",
        rhs = function()
            aux.toggle_sidebar("spectre_panel")
            require("spectre").open()
        end,
        options = { silent = true },
        description = "Replace characters in all files in the current workspace",
    },
    {
        mode = { "n" },
        lhs = "<leader>rf",
        rhs = function()
            aux.toggle_sidebar("spectre_panel")
            -- FIX: Invalid selected word ..
            -- vim.cmd("normal! viw")
            require("spectre").open_file_search()
        end,
        options = { silent = true },
        description = "Replace all characters in the current file",
    },
    {
        mode = { "n" },
        lhs = "<leader>rw",
        rhs = function()
            aux.toggle_sidebar("spectre_panel")
            require("spectre").open_visual({ select_word = true })
        end,
        options = { silent = true },
        description = "Replace the character under the cursor in all files under the current workspace",
    },
})

