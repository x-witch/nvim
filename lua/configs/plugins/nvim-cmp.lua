local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
    vim.notify('cmp not found')
    return
end

local luasnip_status_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_status_ok then
    vim.notify('luasnip not found')
    return
end


-- require("luasnip.loaders.from_snipmate").lazy_load()
-- load freindly-snippets
require("luasnip.loaders.from_vscode").lazy_load()
-- Load snippets from user custom snippets folder
require("luasnip.loaders.from_vscode").load({ paths = {
    vim.fn.stdpath("config") .. "/snippets"
} })

local kind_icons = require('utility.icons').kind

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-p>'] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "buffer" },
        { name = "path" },
        { name = "cmdline" },
        { name = "cmp_tabnine" },
        { name = "vim-dadbod-completion" },
    }),
    formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        max_width = 0,
        format = function(entry, vim_item)
            local max_len = 35 -- 限制提示框的宽度
            if string.len(vim_item.abbr) > max_len then
                vim_item.abbr = string.sub(vim_item.abbr, 1, max_len - 2) .. "···"
            else
                vim_item.abbr = string.format('%-' .. max_len .. 's', vim_item.abbr)
            end
            -- Kind icons
            vim_item.kind = string.format('%s', kind_icons[vim_item.kind] ) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                buffer = "[Buffer]",
                path = "[Path]",
                cmp_tabnine = "[Tabnine]",
                treesitter = "[TS]",
                -- copilot = '[Copilot]'
                -- nvim_lua = "[Lua]",
                -- latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
        end
    },
    view = {
        entries = {
            -- can be "custom", "wildmenu" or "native"
            name = 'custom',
            -- 在底部的时候，提示内容从下到上
            -- selection_order = 'near_cursor',
        },
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
    sorting = {
        comparators = {
            cmp.config.compare.length,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.scopes,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.order,
        },
    },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline('?', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'cmdline' }
    }, {
        { name = 'path' }
    })
})


-- " gray
-- highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
-- " blue
-- highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
-- highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
-- " light blue
-- highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
-- highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
-- highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
-- " pink
-- highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
-- highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
-- " front
-- highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
-- highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
-- highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
-- highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
-- highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4


-- 如果出现方法名补全没有括号可以重写插件方法,实现方法名后自动追加()
-- local keymap = require("cmp.utils.keymap")
-- cmp.confirm = function(option)
--   option = option or {}
--   local e = cmp.core.view:get_selected_entry() or (option.select and cmp.core.view:get_first_entry() or nil)
--   if e then
--     cmp.core:confirm(
--       e,
--       {
--         behavior = option.behavior
--       },
--       function()
--       local myContext = cmp.core:get_context({ reason = cmp.ContextReason.TriggerOnly })
--       cmp.core:complete(myContext)
--       --function() 自动增加()
--       if e and e.resolved_completion_item and
--           (e.resolved_completion_item.kind == 3 or e.resolved_completion_item.kind == 2)
--       then
--         vim.api.nvim_feedkeys(keymap.t("()<Left>"), "n", true)
--       end
--     end
--     )
--     return true
--   else
--     if vim.fn.complete_info({ "selected" }).selected ~= -1 then
--       keymap.feedkeys(keymap.t("<C-y>"), "n")
--       return true
--     end
--     return false
--   end
-- end
