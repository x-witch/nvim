-- https://github.com/github/copilot.vim

local keymap = require("core.keymaps")

local M = {}

function M.entrance()
    M.register_global_key()
    -- Disable default tab completion
    vim.g.copilot_no_tab_map = true
end

function M.register_global_key()
    keymap.register({
        {
            mode = { "i" },
            lhs = "<c-l>",
            rhs = "copilot#Accept('')",
            options = { silent = true, expr = true },
            description = "Suggestions for using copilot",
        },
    })
end

return M
