return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )

            cmp.setup({
                formatting = lsp_zero.cmp_format({ details = true }),
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            -- Templ filetype setup
            vim.filetype.add({ extension = { templ = "templ" } })

            -- Templ format on save
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                pattern = { "*.templ" },
                callback = function()
                    local file_name = vim.api.nvim_buf_get_name(0)
                    vim.cmd(":silent !templ fmt " .. file_name)
                    vim.cmd('e!')
                end
            })

            lsp_zero.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'ansiblels',
                    'clangd',
                    'dockerls',
                    'gopls',
                    'htmx',
                    'lua_ls',
                    'pylsp',
                    'zls',
                    'templ',
                    'html',
                    'tailwindcss',
                    'emmet_ls',
                },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        -- (Optional) Configure lua language server for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                    templ = function()
                        local lspconfig = require('lspconfig')
                        local configs = require('lspconfig.configs')
                        if not configs.templ then
                            configs.templ = {
                                default_config = {
                                    cmd = { "templ", "lsp", "-http=localhost:7474", "-log=/tmp/templ.log" },
                                    filetypes = { "templ" },
                                    root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
                                    settings = {},
                                },
                            }
                        end
                        lspconfig.templ.setup({})
                    end,
                    html = function()
                        require('lspconfig').html.setup({
                            filetypes = { "html", "templ" },
                        })
                    end,
                    htmx = function()
                        require('lspconfig').htmx.setup({
                            filetypes = { "html", "templ" },
                        })
                    end,
                    tailwindcss = function()
                        require('lspconfig').tailwindcss.setup({
                            filetypes = { "templ", "astro", "javascript", "typescript", "react" },
                            init_options = { userLanguages = { templ = "html" } },
                        })
                    end,
                    emmet_ls = function()
                        require('lspconfig').emmet_ls.setup({
                            filetypes = { "templ", "astro", "javascript", "typescript", "react" },
                            init_options = { userLanguages = { templ = "html" } },
                        })
                    end,
                }
            })
        end
    }
}
