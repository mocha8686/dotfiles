return {
	'nvim-pack/nvim-spectre',
	dependencies = 'nvim-lua/plenary.nvim',
	opts = {
		default = {
			replace = {
				cmd = 'oxi',
			},
		},
	},
	keys = {
		{
			'<leader>ss',
			function()
				require('spectre').toggle()
			end,
			desc = 'Togggle Spectre',
		},
		{
			'<leader>sw',
			function()
				require('spectre').open_visual { select_word = true }
			end,
			desc = 'Search word/selection',
		},
		{
			'<leader>sw',
			function()
				require('spectre').open_visual()
			end,
			desc = 'Search word/selection',
			mode = { 'v' },
		},
		{
			'<leader>sp',
			function()
				require('spectre').open_file_search { select_word = true }
			end,
			desc = 'Search current file',
		},
	},
	build = './build.sh',
}
