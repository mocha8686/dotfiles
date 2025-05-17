local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local keys = require 'keys'
local lsp_inlayhints = require 'lsp-inlayhints'
local lsp_signature = require 'lsp_signature'
local lspconfig = require 'lspconfig'
local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'

local sign_define = vim.fn.sign_define
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
	lsp_signature.on_attach(require 'opts.lsp_signature', buf)
	lsp_inlayhints.on_attach(client, buf)

	vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
	keys.map_plugin_keys_buffer('nvim-lspconfig', buf)

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

mason.setup()
mason_lspconfig.setup()
lsp_inlayhints.setup()

vim.lsp.config('*', {
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.config('clangd', {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = (vim.fn.has 'macunix' and { '/usr/local/opt/llvm/bin/clangd' } or nil),
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
