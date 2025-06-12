return {
	'folke/flash.nvim',
	event = 'VeryLazy',
	config = true,
	keys = {
		{
			'z',
			function()
				require('flash').jump()
			end,
			mode = { 'n', 'x', 'o' },
			desc = 'Flash',
		},
		{
			'Z',
			function()
				require('flash').treesitter()
			end,
			mode = { 'n', 'x', 'o' },
			desc = 'Treesitter',
		},
		{
			'r',
			function()
				require('flash').remote()
			end,
			mode = 'o',
			desc = 'Remote',
		},
		{
			'R',
			function()
				require('flash').treesitter_search()
			end,
			mode = { 'x', 'o' },
			desc = 'Treesitter search',
		},
		{
			'<C-s>',
			function()
				require('flash').toggle()
			end,
			mode = { 'c' },
			desc = 'Toggle',
		},
	},
}
