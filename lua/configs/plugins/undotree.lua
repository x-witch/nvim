-- https://github.com/mbbill/undotree

local mapping = require("core.keybinds")

local undotree_dir = vim.fn.stdpath("cache") .. "/undotree"


-- style: default 1, optional: 1 2 3 4
-- vim.g.undotree_WindowLayout = 2

-- custom window
vim.g.undotree_CustomUndotreeCmd = "topleft vertical 30 new"
vim.g.undotree_CustomDiffpanelCmd = "belowright 10 new"

-- auto focus default 0
vim.g.undotree_SetFocusWhenToggle = 1

if vim.fn.has("persistent_undo") == 1 then
    ---@diagnostic disable-next-line: missing-parameter
    local target_path = vim.fn.expand(undotree_dir)
    if not vim.fn.isdirectory(target_path) then
        vim.fn.mkdir(target_path, "p", 0700)
    end
    vim.o.undodir = target_path
    vim.o.undofile = true
end

mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>3",
        -- rhs = ":UndotreeToggle<cr>",
        rhs = function()
            vim.cmd("UndotreeToggle")
        end,
        options = { silent = true },
        description = "Open Undo Explorer",
    },
})

