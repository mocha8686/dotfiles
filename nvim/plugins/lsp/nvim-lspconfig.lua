local util = require 'util'

local function get_keys()
	return {
		{
			'K',
			vim.lsp.buf.hover,
			desc = 'Display hover info',
		},
		{
			'<leader>lD',
			vim.lsp.buf.declaration,
			desc = 'Jump to declaration',
		},
		{
			'<leader>ld',
			require('telescope.builtin').lsp_definitions,
			desc = 'Jump to definition',
		},
		{
			'<leader>li',
			require('telescope.builtin').lsp_implementations,
			desc = 'Show implementations',
		},
		{
			'<leader>lS',
			vim.lsp.buf.signature_help,
			desc = 'Show signature info',
		},
		{
			'<leader>lr',
			require('telescope.builtin').lsp_references,
			desc = 'Show references',
		},
		{
			'<leader>lR',
			vim.lsp.buf.rename,
			desc = 'Rename symbol',
		},
		{
			'<leader>lA',
			vim.lsp.buf.code_action,
			desc = 'Show code actions',
			mode = {
				'n',
				'v',
			},
		},
		{
			'<leader>lf',
			function()
				vim.lsp.buf.format { async = true }
			end,
			desc = 'Format',
		},
		{
			']e',
			function()
				vim.diagnostic.goto_next { float = { scope = 'line' } }
			end,
			desc = 'Next diagnostic',
		},
		{
			'[e',
			function()
				vim.diagnostic.goto_prev { float = { scope = 'line' } }
			end,
			desc = 'Previous diagnostic',
		},
		{
			']t',
			function()
				require('todo-comments').jump_next()
			end,
			desc = 'Next TODO',
		},
		{
			'[t',
			function()
				require('todo-comments').jump_prev()
			end,
			desc = 'Previous TODO',
		},
	}
end

local function setup_keys(buf)
	local keys = get_keys()

	for _, key in ipairs(keys) do
		vim.keymap.set(key.mode or 'n', key[1], key[2], {
			nowait = key.nowait,
			silent = key.silent,
			script = key.script,
			expr = key.expr,
			unique = key.unique,
			noremap = key.noremap,
			desc = key.desc,
			callback = key.callback,
			replace_keycodes = key.replace_keycodes,
			buffer = buf,
		})
	end
end

local function init()
	local cmp_nvim_lsp = require 'cmp_nvim_lsp'
	local lsp_signature = require 'lsp_signature'
	local mason = require 'mason'
	local mason_lspconfig = require 'mason-lspconfig'
	local neoconf = require 'neoconf'

	mason.setup()
	mason_lspconfig.setup()

	neoconf.setup {
		plugins = {
			lua_ls = {
				enabled_for_neovim_config = true,
				enabled = true,
			},
		},
	}

	util.lazy_load 'nvim-lspconfig'

	vim.diagnostic.config {
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = '',
				[vim.diagnostic.severity.WARN] = '',
				[vim.diagnostic.severity.INFO] = '󰋼',
				[vim.diagnostic.severity.HINT] = '󰌵',
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
				[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
				[vim.diagnostic.severity.HINT] = 'DiagnosticSignInfo',
				[vim.diagnostic.severity.INFO] = 'DiagnosticSignHint',
			},
		},
	}

	local function on_attach(client, buf)
		lsp_signature.on_attach({
			bind = true,
			handler_opts = {
				border = 'single',
			},
		}, buf)

		vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		setup_keys(buf)

		if client:supports_method 'textDocument/formatting' then
			local augroup = vim.api.nvim_create_augroup('LSPFormat', { clear = true })
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = augroup,
				buffer = buf,
				callback = function()
					vim.lsp.buf.format {
						async = false,
						bufnr = buf,
					}
				end,
			})
		end

		if client:supports_method 'textDocument/documentHighlight' then
			local augroup = vim.api.nvim_create_augroup('LSPHighlights', { clear = true })
			vim.api.nvim_create_autocmd('CursorHold', {
				group = augroup,
				buffer = buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd('CursorMoved', {
				group = augroup,
				buffer = buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end

	local function on_attach_disable_formatting(client, buf)
		client['server_capabilities']['documentFormattingProvider'] = false
		on_attach(client, buf)
	end

	local capabilities = cmp_nvim_lsp.default_capabilities()

	vim.lsp.config('*', {
		on_attach = on_attach,
		capabilities = capabilities,
	})

	vim.lsp.config('clangd', {
		on_attach = on_attach,
		capabilities = capabilities,
		cmd = (vim.loop.os_uname().sysname == 'Darwin' and { '/usr/local/opt/llvm/bin/clangd' } or nil),
		filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
	})
	vim.lsp.config('denols', {
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			deno = {
				enable = true,
				unstable = true,
				suggest = {
					imports = {
						hosts = {
							['https://deno.land'] = true,
						},
					},
				},
			},
		},
	})

	vim.lsp.config('ts_ls', {
		on_attach = on_attach_disable_formatting,
		capabilities = capabilities,
		settings = {
			javascript = {
				implicitProjectConfig = {
					checkJs = true,
				},
			},
		},
	})

	vim.lsp.config('jsonls', {
		on_attach = on_attach_disable_formatting,
		capabilities = capabilities,
	})

	vim.lsp.config('stylelint_lsp', {
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = { 'astro', 'css', 'html', 'less', 'scss', 'sugarss', 'vue', 'wxss' },
	})

	vim.lsp.config('html', {
		on_attach = on_attach_disable_formatting,
		capabilities = capabilities,
	})

	vim.lsp.config('rust_analyzer', {
		on_attach = on_attach,
		capabilities = capabilities,
	})

	vim.lsp.config('tinymist', {
		on_attach = on_attach,
		capabilities = capabilities,
	})

	vim.lsp.config('eslint', {
		on_attach = on_attach,
		capabilities = capabilities,
		root_markers = { 'eslint.config.js' },
	})

	vim.lsp.config('astro', {
		on_attach = on_attach_disable_formatting,
		capabilities = capabilities,
	})
end

return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'folke/neoconf.nvim',
		'hrsh7th/nvim-cmp',
		'nvim-telescope/telescope.nvim',
		'nvimtools/none-ls.nvim',
		'ray-x/lsp_signature.nvim',
		'williamboman/mason-lspconfig.nvim',
		'williamboman/mason.nvim',
	},
	event = 'InsertEnter',
	init = init,
}
