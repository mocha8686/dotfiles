return {
	'kosayoda/nvim-lightbulb',
	dependencies = 'neovim/nvim-lspconfig',
	event = 'VeryLazy',
	opts = {
		autocmd = {
			enabled = true,
		},
	},
	config = true,
}
