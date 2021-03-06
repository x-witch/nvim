local M = {}

local function ends_with(str, ending)
    return ending == "" or str:sub(- #ending) == ending
end

M.setup = function()
    local config_dir = vim.fn.stdpath('config') .. '/lua/configs/plugins'
    -- plugins do not need to load, NOTE: no .lua suffix required
    local unload_plugins = {
        "init", -- we don't need to load init again
        "nvim-markdown-previewrkdown-prview",
        "translate",
        "neoformat",
        "sniprun",
        "venn",
        "vim-vsnip",
        "spellsitter",
        "persisted",
        "nvim-spectre",
    }

    local helper_set = {}

    for _, v in pairs(unload_plugins) do
        helper_set[v] = true
    end

    for _, fname in pairs(vim.fn.readdir(config_dir)) do
        if ends_with(fname, ".lua") then
            local cut_suffix_fname = fname:sub(1, #fname - #'.lua')
            if helper_set[cut_suffix_fname] == nil then
                local file = "configs.plugins." .. cut_suffix_fname
                local status_ok, _ = pcall(require, file)
                if not status_ok then
                    vim.notify('Failed loading ' .. fname, vim.log.levels.ERROR)
                end
            end
        end
    end
end

M.setup()
