local M = {}

M.setup = function()
  local config_dir = vim.fn.stdpath('config') .. '/lua/configs/plugins'
  -- plugins do not need to load, NOTE: no .lua suffix required
  local unload_plugins = {
      "init",
      "sniprun",
      "nvim-lint",
  }

  local helper_set = {}
  for _, v in pairs(unload_plugins) do
    helper_set[v] = true
  end
  for _, fname in pairs(vim.fn.readdir(config_dir)) do
    if require("core.utils").ends_with(fname, ".lua") then
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
