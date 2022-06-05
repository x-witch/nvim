-- https://github.com/mg979/vim-visual-multi

local mapping = require("core.mappings")


vim.g.VExtend_hl = "VM_Extend_hi"
vim.g.VCursor_hl = "VM_Cursor_hi"
vim.g.VMono_hl = "VM_Mono_hi"
vim.g.VInsert_hl = "VM_Insert_hi"
vim.g.Vdefault_mappings = 0

vim.g.Vmaps = {
    ["Find Under"] = "<c-n>",
    ["Find Prev"] = "<c-p>",
    ["Skip Region"] = "<c-s>",
    ["Remove Region"] = "<c-d>",
}

mapping.register({
    {
        mode = { "n" },
        lhs = "<m-p>",
        rhs = ":call vm#commands#add_cursor_up(0, v:count1)<cr>",
        options = { silent = true },
        description = "Create cursor down",
    },
    {
        mode = { "n" },
        lhs = "<m-n>",
        rhs = ":call vm#commands#add_cursor_down(0, v:count1)<cr>",
        options = { silent = true },
        description = "Create cursor up",
    },
})

