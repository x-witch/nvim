-- https://github.com/dstein64/nvim-scrollview
local status_ok, scrollview = pcall(require, "scrollview")
if not status_ok then
  vim.notify("scrollview not found!")
  return
end

scrollview.setup({
    -- Do not display scrollbars for the following file types
    excluded_filetypes = {
        "NvimTree",
        "aerial",
        "undotree",
        "spectre_panel",
        "dbui",
        "lsp-installer",
    },
    -- only show in current window
    current_only = true,
    -- Transparency
    winblend = 0,
    base = "right",
    -- offset
    column = 1,
    character = "",
})


