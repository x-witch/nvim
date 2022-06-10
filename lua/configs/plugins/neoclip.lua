-- https://github.com/AckslD/nvim-neoclip.lua

local mapping = require("core.keybinds")

local ok, neoclip = pcall(require, "neoclip")
if not ok then
    return
end

local all = function(tbl, check)
    for _, entry in ipairs(tbl) do
        if not check(entry) then
            return false
        end
    end
    return true
end

local is_whitespace = function(line)
    return vim.fn.match(line, [[^\s*$]]) ~= -1
end
neoclip.setup({
    -- preview = false,
    -- content_spec_column = true,
    history = 1000,
    enable_persistent_history = true,
    continuous_sync = true,
    db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
    keys = {
        telescope = {
            i = {
                select = "<nop>",
                paste = "<cr>",
                paste_behind = "<nop>",
                replay = "<nop>",
                delete = "<c-d>",
                custom = {},
            },
            n = {
                select = "<nop>",
                paste = "<cr>",
                paste_behind = "<nop>",
                replay = "<nop>",
                delete = "dd",
                custom = {},
            },
        },
    },
    -- Filter blank lines
    filter = function(data)
        return not all(data.event.regcontents, is_whitespace)
    end,
})


mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>fy",
        rhs = function()
            require("telescope").extensions.neoclip.default()
        end,
        options = { silent = true },
        description = "Find Clipboard History",
    },
    {
        mode = { "n" },
        lhs = "<leader>cy",
        rhs = function()
            require("neoclip").clear_history()
        end,
        options = { silent = true },
        description = "Clear Clipboard History",
    },
})

