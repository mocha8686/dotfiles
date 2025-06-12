local util = require 'util'

return {
	'akinsho/git-conflict.nvim',
	version = '*',
	init = util.git_lazy_load 'git-conflict.nvim',
	opts = {
		highlights = {
			incoming = 'DiffDelete',
			current = 'DiffChange',
		},
	},
}
