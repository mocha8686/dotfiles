local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local keys = require 'keys'
local lsp_signature = require 'lsp_signature'
local lspconfig = require 'lspconfig'
local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'
local neoconf = require 'neoconf'
local neodev = require 'neodev'

local sign_define = vim.fn.sign_define
sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

local function on_attach(client, buf)
	lsp_signature.on_attach(require 'opts.lsp_signature', buf)

	vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
	keys.map_plugin_keys_buffer('nvim-lspconfig', buf)

	if client.supports_method 'textDocument/formatting' then
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

	if client.supports_method 'textDocument/documentHighlight' then
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

local capabilities = cmp_nvim_lsp.default_capabilities()

neoconf.setup()
neodev.setup()
mason.setup()
mason_lspconfig.setup()

mason_lspconfig.setup_handlers {
	function(server)
		lspconfig[server].setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}
	end,
	['rust_analyzer'] = function()
		lspconfig['rust_analyzer'].setup {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				procMacro = {
					ignored = {
						leptos_macro = {
							'server',
							'component',
						},
					},
				},
			},
		}
	end,
	['clangd'] = function()
		lspconfig['clangd'].setup {
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = (vim.fn.has 'macunix' and { '/usr/local/opt/llvm/bin/clangd' } or nil),
			filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
		}
	end,
}
