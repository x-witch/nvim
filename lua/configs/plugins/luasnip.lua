local ok, luasnip = pcall(require, "luasnip")
if not ok then
  vim.notify "Could not load luasnip"
  return
end

local mapping = require("core.mappings")
local cmp = require('cmp')
return function()
  luasnip.config.set_config({
    history = true,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
  })

  require("luasnip/loaders/from_vscode").lazy_load()
  -- Load snippets from user custom snippets folder
  require("luasnip.loaders.from_vscode").load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

  local function on_tab()
    return luasnip.jump(1) and "" or vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
  end

  --- <s-tab> to jump to next snippet's placeholder
  local function on_s_tab()
    return luasnip.jump(-1) and "" or vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
  end

  mapping.register({
    {
      mode = { "i" },
      lhs = "<Tab>",
      rhs = on_tab,
      options = { expr = true },
      description = "快捷键",
    },
    {
      mode = { "i" },
      lhs = "<S-Tab>",
      rhs = on_s_tab,
      options = { expr = true },
      description = "快捷键",
    },
  })
end
