local util = require 'util'

return {
	'folke/trouble.nvim',
	dependencies = {
		'neovim/nvim-lspconfig',
		'nvim-tree/nvim-web-devicons',
	},
	init = util.lsp_lazy_load 'trouble.nvim',
	keys = {
		{ '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics' },
		{ '<leader>xl', '<Cmd>Trouble loclist toggle<CR>',     desc = 'Location list' },
		{ '<leader>xq', '<Cmd>Trouble qflist toggle<CR>',      desc = 'Quickfix' },
		{ '<leader>xt', '<Cmd>TodoTrouble<CR>',                desc = 'TODOs' },
		{
			'<leader>xr',
			'<Cmd>Trouble lsp toggle focus=false win.position=bottom<CR>',
			desc = 'LSP definitions / references / ...',
		},
	},
	config = true,
}
