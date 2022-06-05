local status_ok, aerial = pcall(require, "aerial")
if not status_ok then
  vim.notify("aerial not found")
  return
end

local icons = require("common.icons")
local mapping = require("core.mappings")

-- Call the setup function to change the default behavior
aerial.setup({
    -- Minimum width
    min_width = 30,
    -- Backend for rendering symbols
    backends = { "lsp", "treesitter", "markdown" },
    -- If set to False, show all icons, otherwise show already
    -- Defined icon
    -- filter_kind = false,
    filter_kind = {
        "Module",
        "Struct",
        "Interface",
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Method",
        -- customize
        "Property",
    },
    -- Icon to use
    icons = icons[kind],
    -- Show box drawing characters for the tree hierarchy
    show_guides = true,
    -- Event to update symbol tree
    update_events = "TextChanged,InsertLeave",
    -- Bind keys
    on_attach = function(bufnr)
        register_buffer_key(bufnr)
    end,
    -- Customize the characters used when show_guides = true
    guides = {
        -- When the child item has a sibling below it
        mid_item = "├─",
        -- When the child item is the last in the list
        last_item = "└─",
        -- When there are nested child guides to the right
        nested_top = "│ ",
        -- Raw indentation
        whitespace = "  ",
    },
    lsp = {
        -- Fetch document symbols when LSP diagnostics update.
        -- If false, will update on buffer changes.
        diagnostics_trigger_update = false,
        -- Set to false to not update the symbols when there are LSP errors
        update_when_errors = true,
        -- How long to wait (in ms) after a buffer change before updating
        -- Only used when diagnostics_trigger_update = false
        update_delay = 300,
    },
})

function register_buffer_key(bufnr)
    mapping.register({
        {
            mode = { "n" },
            lhs = "<leader>2",
            rhs = "<cmd>AerialToggle! right<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Open Outilne Explorer",
        },
        {

            mode = { "n" },
            lhs = "{",
            rhs = "<cmd>AerialPrev<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Move item up",
        },
        {

            mode = { "n" },
            lhs = "}",
            rhs = "<cmd>AerialNext<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Move item down",
        },
        {

            mode = { "n" },
            lhs = "[[",
            rhs = "<cmd>AerialPrevUp<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Move up one level",
        },
        {

            mode = { "n" },
            lhs = "]]",
            rhs = "<cmd>AerialNextUp<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Move down one level",
        },
    })
end
