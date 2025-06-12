return {
	'nvimtools/none-ls.nvim',
	dependencies = {
		'jay-babu/mason-null-ls.nvim',
		'neovim/nvim-lspconfig',
		'nvim-lua/plenary.nvim',
		'williamboman/mason.nvim',
	},
	opts = function()
		local null_ls = require 'null-ls'

		return {
			sources = {
				null_ls.builtins.formatting.stylelint.with {
					extra_filetypes = { 'astro', 'html' },
				},
			},
		}
	end,
}
