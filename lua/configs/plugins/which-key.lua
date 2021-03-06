-- https://github.com/folke/which-key.nvim
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end


-- FIX: <telescope c-r> bug
local show = which_key.show
which_key.show = function(keys, opts)
    if vim.bo.filetype == "TelescopePrompt" then
        local map = "<c-r>"
        local key = vim.api.nvim_replace_termcodes(map, true, false, true)
        vim.api.nvim_feedkeys(key, "i", true)
    end
    show(keys, opts)
end

which_key.setup({
    plugins = {
        spelling = {
            enabled = false,
            suggestions = 20,
        },
    },
    icons = {
        breadcrumb = " ",
        separator = " ",
        group = " ",
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
})

-- global leader
which_key.register({
    b = { name = "Buffers" },
    c = { name = "Code" },
    d = { name = "Debug" },
    f = { name = "Find" },
    g = { name = "Git" },
    r = { name = "Replace" },
    s = { name = "Session" },
    u = { name = "Upload" },
    t = {
        name = "Terminal | Translate",
        c = "Translate English to Chinese",
        e = "Translate Chinese to English",
    },
}, { prefix = "<leader>", mode = "n" })

-- comment
which_key.register({
    c = {
        name = "Comment",
        c = "Toggle line comment",
        b = "Toggle block comment",
        a = "Insert line comment to line end",
        j = "Insert line comment to next line",
        k = "Insert line comment to previous line",
    },
}, { prefix = "g", mode = "n" })

which_key.register({
    c = "Switch the specified line to a line comment",
    b = "Switch the specified line to a block comment",
}, { prefix = "g", mode = "v" })

-- surround
which_key.register({
    q = "Switch Surround", s = "Change Surround",
}, { prefix = "c", mode = "n" })

which_key.register({
    s = "Delete Surround",
}, { prefix = "d", mode = "n" })

which_key.register({
    s = "Add Surround",
}, { prefix = "y", mode = "n" })
