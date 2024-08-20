local lsp = require('lsp-zero')

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		['<C-Space>'] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
})

lsp.on_attach(function(client, bufnr)
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
end)

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'lua_ls',
		'rust_analyzer',
		'cmake',
		'clangd',
		'zls',
        'pylsp',
        'glsl_analyzer'
	},
	handlers = {
		function(server_name)
            local config = {}
            local lspconfig = require('lspconfig')

            if server_name == 'cmake' then
                config = {
                    -- Path to the compile_commands.json file
                    cmd = { 'cmake-language-server', '-E', 'stdin=1', '--', '-DCMAKE_EXPORT_COMPILE_COMMANDS=YES' },
                    filetypes = { 'cmake' },
                    root_dir = lspconfig.util.root_pattern("compile_commands.json", "CMakeLists.txt"),
                }
            end

            lspconfig[server_name].setup(config)
		end,
	},
})

lsp.setup()
