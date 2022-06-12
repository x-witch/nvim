-- 更多样式定制，参见：https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
-- 1. 安装 nvim-lspconfig
-- 2. 安装对应 language server(需要nvim-lsp-installer自动安装)
-- 3. 配置对应语言 require('lspconfig').xx.setup{…}
-- 4. :lua print(vim.inspect(vim.lsp.buf_get_clients())) 查看 LSP 连接状态-- Setup installer & lsp configs
-- install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" }
-- 安装i,更新u,检查版本c,全部更新U,检测过时版本C,卸载X

-- Setup lsp-config & installer

local mapping = require("core.keybinds")
local icons = require("utility.icons")

-- 诊断样式定制
local signs = icons.diagnostics
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
    signs = true,
    virtual_text = false, -- virtual_text = { prefix = "●", source = "always" },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = { source = "always" },
})
-- TODO: Use lsp_signature instead
vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

local border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
}

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- 配置 nvim-lsp-installer，它只负责下载 LSP 服务器
local nvim_lsp_installer = require("nvim-lsp-installer")
nvim_lsp_installer.setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = { "sumneko_lua", "pyright", "jsonls" },
    -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed
    automatic_installation = false,
    -- github = {
    --   -- 针对中国用户，如果 LSP 服务器下载太慢，可以使用下面的镜像站
    --   -- download_url_template = "https://hub.fastgit.xyz/%s/releases/download/%s/%s",
    --   download_url_template = "https://github.com/%s/releases/download/%s/%s",
    -- },
    -- max_concurrent_installers = 20,
})

-- 需要通过 lspconfig 插件启动 LSP 服务器,所以这里将它导入进来
local lspconfig = require("lspconfig")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 5, prefix = "●", severity_limit = "Warning" },
    severity_sort = true,
})

-- 悬浮文档和签名帮助有浮动边框
local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

local function register_buffer_key(bufnr)
    mapping.register({
        {
            mode = { "n" },
            lhs = "<leader>ca",
            rhs = vim.lsp.buf.code_action,
            options = { silent = true },
            description = "Show code action",
        },
        {
            mode = { "n" },
            lhs = "<leader>cn",
            rhs = vim.lsp.buf.rename,
            options = { silent = true },
            description = "Variable renaming",
        },
        {
            mode = { "n" },
            lhs = "<leader>cf",
            rhs = vim.lsp.buf.formatting_sync,
            options = { silent = true },
            description = "Format buffer",
        },
        {
            mode = { "n" },
            lhs = "gI",
            rhs = function()
                require("telescope.builtin").lsp_implementations()
            end,
            options = { silent = true },
            description = "Go to implementations",
        },
        {
            mode = { "n" },
            lhs = "gD",
            rhs = function()
                require("telescope.builtin").lsp_type_definitions()
            end,
            options = { silent = true },
            description = "Go to type definitions",
        },
        {
            mode = { "n" },
            lhs = "gd",
            rhs = function()
                require("telescope.builtin").lsp_definitions()
            end,
            options = { silent = true, },
            description = "Go to definitions",
        },
        {
            mode = { "n" },
            lhs = "gr",
            rhs = function()
                require("telescope.builtin").lsp_references()
            end,
            options = { silent = true },
            description = "Go to references",
        },
        {
            mode = { "n" },
            lhs = "gh",
            rhs = vim.lsp.buf.hover,
            options = { silent = true },
            description = "Show help information",
        },
        {
            mode = { "n" },
            lhs = "go",
            rhs = function()
                require("telescope.builtin").diagnostics()
            end,
            options = { silent = true },
            description = "Show Workspace Diagnostics",
        },
        {
            mode = { "n" },
            lhs = "[g",
            rhs = function()
                vim.diagnostic.goto_prev({ float = { border = "rounded" } })
            end,
            options = { silent = true, },
            description = "Jump to prev diagnostic",
        },
        {
            mode = { "n" },
            lhs = "]g",
            rhs = function()
                vim.diagnostic.goto_next({ float = { border = "rounded" } })
            end,
            options = { silent = true },
            description = "Jump to next diagnostic",
        },
        {
            mode = { "i" },
            lhs = "<c-j>",
            rhs = function()
                -- When the signature is visible, pressing <c-j> again will close the window
                local wins = vim.api.nvim_list_wins()
                for _, win_id in ipairs(wins) do
                    local buf_id = vim.api.nvim_win_get_buf(win_id)
                    local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")
                    if ft == "lsp-signature-help" then
                        vim.api.nvim_win_close(win_id, false)
                        return
                    end
                end
                vim.lsp.buf.signature_help()
            end,
            options = { silent = true },
            description = "Toggle signature help",
        },
        {
            mode = { "i", "n" },
            lhs = "<c-f>",
            rhs = function()
                local scroll_floating_filetype = { "lsp-signature-help", "lsp-hover" }
                local wins = vim.api.nvim_list_wins()

                for _, win_id in ipairs(wins) do
                    local buf_id = vim.api.nvim_win_get_buf(win_id)
                    local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")

                    if vim.tbl_contains(scroll_floating_filetype, ft) then
                        local win_height = vim.api.nvim_win_get_height(win_id)
                        local cursor_line = vim.api.nvim_win_get_cursor(win_id)[1]
                        local buf_total_line = vim.api.nvim_buf_line_count(buf_id)
                        ---@diagnostic disable-next-line: redundant-parameter
                        local win_last_line = vim.fn.line("w$", win_id)

                        if buf_total_line == win_height then
                            vim.api.nvim_echo({ { "Can't scroll down", "MoreMsg" } }, false, {})
                            return
                        end

                        vim.opt.scrolloff = 0
                        if cursor_line < win_last_line then
                            vim.api.nvim_win_set_cursor(win_id, { win_last_line + 5, 0 })
                        elseif cursor_line + 5 > buf_total_line then
                            vim.api.nvim_win_set_cursor(win_id, { buf_total_line, 0 })
                        else
                            vim.api.nvim_win_set_cursor(win_id, { cursor_line + 5, 0 })
                        end
                        return
                    end
                end

                local map = "<c-f>"
                local key = vim.api.nvim_replace_termcodes(map, true, false, true)
                vim.api.nvim_feedkeys(key, "n", true)
            end,
            options = { silent = true },
            description = "Scroll down floating window",
        },
        {
            mode = { "i", "n" },
            lhs = "<c-b>",
            rhs = function()
                local scroll_floating_filetype = { "lsp-signature-help", "lsp-hover" }
                local wins = vim.api.nvim_list_wins()

                for _, win_id in ipairs(wins) do
                    local buf_id = vim.api.nvim_win_get_buf(win_id)
                    local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")

                    if vim.tbl_contains(scroll_floating_filetype, ft) then
                        local win_height = vim.api.nvim_win_get_height(win_id)
                        local cursor_line = vim.api.nvim_win_get_cursor(win_id)[1]
                        local buf_total_line = vim.api.nvim_buf_line_count(buf_id)
                        ---@diagnostic disable-next-line: redundant-parameter
                        local win_first_line = vim.fn.line("w0", win_id)

                        if buf_total_line == win_height then
                            vim.api.nvim_echo({ { "Can't scroll up", "MoreMsg" } }, false, {})
                            return
                        end

                        vim.opt.scrolloff = 0
                        if cursor_line > win_first_line then
                            vim.api.nvim_win_set_cursor(win_id, { win_first_line - 5, 0 })
                        elseif cursor_line - 5 < 1 then
                            vim.api.nvim_win_set_cursor(win_id, { 1, 0 })
                        else
                            vim.api.nvim_win_set_cursor(win_id, { cursor_line - 5, 0 })
                        end

                        return
                    end
                end

                local map = "<c-b>"
                local key = vim.api.nvim_replace_termcodes(map, true, false, true)
                vim.api.nvim_feedkeys(key, "n", true)
            end,
            options = { silent = true },
            description = "Scroll up floating window",
        },
    })
end

-- 这是一个回调函数，在 LSP 服务器开始工作前会自动调用
local function on_attach(client, bufnr)
    -- set up buffer keymaps
    require("aerial").on_attach(client, bufnr)
    require("lsp_signature").on_attach()
    register_buffer_key(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

capabilities.textDocument.codeAction = {
    dynamicRegistration = false,
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = {
                "",
                "quickfix",
                "refactor",
                "refactor.extract",
                "refactor.inline",
                "refactor.rewrite",
                "source",
                "source.organizeImports",
            },
        },
    },
}

-- 启动 LSP 服务器
local language_servers_config = {
    sumneko_lua = require("configs.lsp.sumneko_lua"),
    pyright = require("configs.lsp.pyright"),
    jsonls = require("configs.lsp.jsonls"),
}

-- 循环 LSP 服务器名称和配置
for server_name, server_settings in pairs(language_servers_config) do
    local server_available, server = nvim_lsp_installer.get_server(server_name)
    -- 判断 LSP 服务器是否有效
    if server_available then
        -- 判断 LSP 服务器是否已下载
        -- 若未下载则自动下载
        ---@diagnostic disable-next-line: undefined-field
        if not server:is_installed() then
            vim.notify("Install Language Server: " .. server_name, "info", { title = "Language Server" })
            ---@diagnostic disable-next-line: undefined-field
            server:install()
        else
            -- 如果 LSP 服务器已经下载，则将配置文件导入
            local lsp_config = {
                handlers = handlers,
                on_attach = on_attach,
                capabilities = capabilities,
                settings = server_settings.settings,
                flags = {
                    debounce_text_changes = 150,
                },
            }
            -- 启动 LSP 服务器
            lspconfig[server_name].setup(lsp_config)
        end
    end
end

-- lspconfig.sumneko_lua.setup {
--   handlers = handlers,
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = require('lsp.svr-settings.sumneko_lua').settings,
-- }
--
--
-- lspconfig.pyright.setup {
--   handlers = handlers,
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = require('lsp.svr-settings.pyright').settings,
-- }
--
-- lspconfig.jsonls.setup {
--   handlers = handlers,
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = require('lsp.svr-settings.jsonls').settings,
-- }
