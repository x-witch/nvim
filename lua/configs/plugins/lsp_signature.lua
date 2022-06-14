-- https://github.com/ray-x/lsp_signature.nvim
local status_ok, lsp_signature = pcall(require, 'lsp_signature')
if not status_ok then
    vim.notify('lsp-signature not found')
    return
end

lsp_signature.setup({
    handler_opts = {
        bind = true,
        -- double, rounded, single, shadow, none
        -- double 显示提示和注释
        border = 'rounded',
    },
    hint_enable = false, -- virtual hint enable
    hint_prefix = "🐼 ",
    floating_window = false,
    floating_window_above_cur_line = false,
    extra_trigger_chars = {'(', ','},
})
