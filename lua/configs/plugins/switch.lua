-- https://github.com/AndrewRadev/switch.vim

-- NOTE: switch 手动定义需要增加的反意单词

local mapping = require("core.keybinds")

local str_title = function(s)
    return (s:gsub("(%a)([%w_']*)", function(f, r)
        return f:upper() .. r:lower()
    end))
end

local word_antisense_switch = {
    { "true", "false" },
    { "on", "off" },
    { "yes", "no" },
    { "disable", "enable" },
    { "open", "close" },
    { "in", "out" },
    { "resolve", "reject" },
    { "start", "end" },
    { "before", "after" },
    { "from", "to" },
    { "relative", "absolute" },
    { "up", "down" },
    { "left", "right" },
    { "row", "column" },
    { "drak", "light" },
    { "white", "black" },
    { "get", "post" },
    { "+", "-" },
    { ">", "<" },
    { "=", "!=" },
}
local variable_style_switch = {
    {
        ["\\<[a-z0-9]\\+_\\k\\+\\>"] = {
            ["_\\(.\\)"] = "\\U\\1",
        },
    },
    {
        ["\\<[a-z0-9]\\+[A-Z]\\k\\+\\>"] = {
            ["\\([A-Z]\\)"] = "_\\l\\1",
        },
    },
}

local put_words = vim.deepcopy(word_antisense_switch)

for _, value in ipairs(word_antisense_switch) do
    local upper_words = { string.upper(value[1]), string.upper(value[2]) }
    local title_words = { str_title(value[1]), str_title(value[2]) }
    table.insert(put_words, upper_words)
    table.insert(put_words, title_words)
end

vim.g.switch_custom_definitions = put_words
vim.g.variable_style_switch_definitions = variable_style_swit

mapping.register({
    {
        mode = { "n" },
        lhs = "gs",
        rhs = ":Switch<cr>",
        options = { silent = true },
        description = "Switch the opposite meaning of the word",
    },
    {
        mode = { "n" },
        lhs = "gS",
        rhs = function()
            vim.fn["switch#Switch"]({ definitions = vim.g.variable_style_switch_definitions })
        end,
        options = { silent = true },
        description = "Switch variable naming style",
    },
})

