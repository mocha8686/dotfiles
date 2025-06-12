return {
	'danymat/neogen',
	config = true,
	keys = {
		{
			'<leader>lgg',
			function()
				require('neogen').generate()
			end,
			desc = 'Generate docstring',
		},
		{
			'<leader>lgf',
			function()
				require('neogen').generate { type = 'func' }
			end,
			desc = 'Generate function docstring',
		},
		{
			'<leader>lgc',
			function()
				require('neogen').generate { type = 'class' }
			end,
			desc = 'Generate class docstring',
		},
		{
			'<leader>lgt',
			function()
				require('neogen').generate { type = 'type' }
			end,
			desc = 'Generate type docstring',
		},
	},
}
