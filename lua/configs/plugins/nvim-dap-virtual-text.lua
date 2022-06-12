-- https://github.com/theHamsta/nvim-dap-virtual-text


local ok, nvim_dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not ok then
    return
end

nvim_dap_virtual_text.setup()
