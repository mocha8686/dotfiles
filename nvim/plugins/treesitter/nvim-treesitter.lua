local util = require 'util'

return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	dependencies = {
		'RRethy/nvim-treesitter-endwise',
		'nvim-treesitter/nvim-treesitter-refactor',
		'windwp/nvim-ts-autotag',
	},
	cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
	init = util.lazy_load 'nvim-treesitter',
	opts = {
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = false },
		endwise = { enable = true },
		autotag = { enable = true },
	},
	config = function(_, opts)
		require('nvim-treesitter.configs').setup(opts)
	end,
}
