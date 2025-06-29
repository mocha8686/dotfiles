return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	opts = {
		preset = 'helix',
		spec = {
			{ '<leader>a',  group = 'Animate' },
			{ '<leader>c',  group = 'Colors' },
			{ '<leader>d',  group = 'DAP' },
			{ '<leader>f',  group = 'Flash' },
			{ '<leader>i',  group = 'Autolist' },
			{ '<leader>l',  group = 'LSP' },
			{ '<leader>lf', group = 'Neogen' },
			{ '<leader>s',  group = 'Spectre' },
			{ '<leader>t',  group = 'Terminal' },
			{ '<leader>x',  group = 'Trouble' },
			{ '<leader>f', group = 'Writing' },
			{ '<leader>v', group = 'Leet' },
		},
	},
	config = true,
}
