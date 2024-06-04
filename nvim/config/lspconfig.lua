local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local keys = require 'keys'
local lsp_format = require 'lsp-format'
local lsp_signature = require 'lsp_signature'
local lspconfig = require 'lspconfig'
local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'
local neoconf = require 'neoconf'
local neodev = require 'neodev'
local notify = require 'notify'.notify

local sign_define = vim.fn.sign_define
sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

vim.lsp.handlers['window/showMessage'] = function(_, method, params, _)
	local severity = {
		'error',
		'warn',
		'info',
		'hint',
	}

	notify(method.message, severity[params.type])
end

local function on_attach(client, buf)
	lsp_signature.on_attach(require 'opts.lsp_signature', buf)
	lsp_format.on_attach(client)

	vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
	keys.map_plugin_keys_buffer('nvim-lspconfig', buf)

	if client.server_capabilities.documentFormattingProvider then
		vim.cmd [[ cabbrev wq execute 'Format sync' <bar> wq ]]
	end

	if client.server_capabilities.documentHighlightProvider then
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

mason.setup()
mason_lspconfig.setup()
neoconf.setup()
neodev.setup()
lsp_format.setup()

mason_lspconfig.setup_handlers {
	function(server)
		lspconfig[server].setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}
	end,
}
