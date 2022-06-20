-- https://github.com/olimorris/persisted.nvim
-- 用于 Neovim 中的自动会话管理。
local mapping = require("core.keybinds")

local ok, persisted = pcall(require, "persisted")
if not ok then
    return
end

persisted.setup({
    save_dir = vim.fn.stdpath("cache") .. "/sessions",
    use_git_branche = true,
    command = "VimLeavePre",
    autosave = true,
})


mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>sl",
        rhs = function()
            vim.cmd("silent! SessionLoad")
            -- Reload lsp servers
            pcall(vim.cmd, "edit")
        end,
        options = { silent = true },
        description = "Load session",
    },
    {
       mode = { "n" },
        lhs = "<leader>ss",
        rhs = function()
            vim.cmd("silent! SessionSave")
            print("Session saved successfully")
        end,
        options = { silent = true },
        description = "Save session",
    },
    {
        mode = { "n" },
        lhs = "<leader>sd",
        rhs = function()
            local ok, _ = pcall(vim.cmd, "SessionDelete")
            if ok then
                print("Session deleted successfully")
            else
                print("Session deleted failed, file has been deleted")
            end
        end,
        options = { silent = true },
        description = "Delete session",
    },
})
