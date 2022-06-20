-- https://github.com/theHamsta/nvim-dap-virtual-text
local status_ok, ndvt = pcall(require, 'nvim-dap-virtual-text')
if not status_ok then
    vim.notify('nvim-dap-virtual-text not found')
    return
end

ndvt.setup {
    enabled = true,

    -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
    enabled_commands = false,

    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_changed_variables = true,
    highlight_new_as_changed = true,

    -- prefix virtual text with comment string
    commented = false,

    show_stop_reason = true,

    -- experimental features:
    virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
}
