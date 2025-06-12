local util = require 'util'

return {
	'lewis6991/gitsigns.nvim',
	init = util.git_lazy_load 'gitsigns.nvim',
	opts = {
		attach_to_untracked = false,
	},
}
