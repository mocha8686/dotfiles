return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	opts = {
		preset = 'helix',
		spec = {
			{ '<leader>a', group = 'Animate' },
			{ '<leader>c', group = 'Colors' },
			{ '<leader>d', group = 'DAP' },
			{ '<leader>f', group = 'Writing' },
			{ '<leader>l', group = 'LSP' },
			{ '<leader>m', group = 'Venn' },
			{ '<leader>s', group = 'Spectre' },
			{ '<leader>t', group = 'Terminal' },
			{ '<leader>v', group = 'Leet' },
			{ '<leader>x', group = 'Trouble' },
		},
	},
	config = true,
}
