local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

-- https://github.com/akinsho/toggleterm.nvim

local mapping = require("core.keybinds")

local vertical_term = nil
local floating_term = nil
local lazygit_term = nil


local terms = require("toggleterm.terminal").Terminal

toggleterm.setup({
    start_in_insert = true,
    shade_terminals = true,
    shading_factor = 1,
    size = function(term)
        if term.direction == "horizontal" then
            return vim.o.lines * 0.2
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.25
        end
    end,
    on_open = function()
        vim.wo.spell = false
    end,
    highlights = {
        Normal = {
            link = "Normal",
        },
        NormalFloat = {
            link = "NormalFloat",
        },
        FloatBorder = {
            link = "FloatBorder",
        },
    },
})


-- create terminal
vertical_term = terms:new({
    direction = "vertical",
})

floating_term = terms:new({
    hidden = true,
    count = 120,
    direction = "float",
    float_opts = {
        border = "double",
    },
    on_open = function(term)
        open_callback()
        vim.keymap.set({ "t" }, "<esc>", "<c-\\><c-n><cmd>close<cr>", { silent = true, buffer = term.bufnr })
    end,
    on_close = close_callback,
})

lazygit_term = terms:new({
    cmd = "lazygit",
    count = 130,
    hidden = true,
    direction = "float",
    float_opts = {
        border = "double",
    },
    on_open = function(term)
        open_callback()
        vim.keymap.set({ "i" }, "q", "<cmd>close<cr>", { silent = true, buffer = term.bufnr })
    end,
    on_close = close_callback,
})

-- define new method
toggleterm.vertical_toggle = function()
    ---@diagnostic disable-next-line: missing-parameter
    vertical_term:toggle()
end

toggleterm.float_toggle = function()
    ---@diagnostic disable-next-line: missing-parameter
    floating_term:toggle()
end

toggleterm.lazygit_toggle = function()
    ---@diagnostic disable-next-line: missing-parameter
    lazygit_term:toggle()
end

toggleterm.term_toggle = function()
    vim.cmd("exe v:count1.'ToggleTerm'")
end

toggleterm.toggle_all_term = function()
    vim.cmd("ToggleTermToggleAll")
end

function open_callback()
    -- enter insert mode
    vim.cmd("startinsert")
    -- unmap esc
    vim.keymap.del({ "t" }, "<esc>")
end

function close_callback()
    vim.keymap.set({ "t" }, "<esc>", "<c-\\><c-n>", { silent = true })
end

mapping.register({
    {
        mode = { "n" },
        lhs = "<leader>tt",
        rhs = function()
            require("toggleterm").term_toggle()
        end,
        options = { silent = true },
        description = "Toggle bottom or vertical terminal",
    },
    {
        mode = { "n" },
        lhs = "<leader>tf",
        rhs = function()
            require("toggleterm").float_toggle()
        end,

        options = { silent = true },
        description = "Toggle floating terminal",
    },
    {
        mode = { "n" },
        lhs = "<leader>tv",
        rhs = function()
            require("toggleterm").vertical_toggle()
        end,
        options = { silent = true },
        description = "Toggle vertical terminal",
    },
    {
        mode = { "n" },
        lhs = "<leader>tg",
        rhs = function()
            require("toggleterm").lazygit_toggle()
        end,
        options = { silent = true },
        description = "Toggle lazygit terminal",
    },
    {
        mode = { "n" },
        lhs = "<leader>ta",
        rhs = function()
            require("toggleterm").toggle_all_term()
        end,
        options = { silent = true },
        description = "Toggle all terminal",
    },
})

