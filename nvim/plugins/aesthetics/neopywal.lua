return {
	'RedsXDD/neopywal.nvim',
	name = 'neopywal',
	tag = 'v2.6.0',
	lazy = false,
	priority = 1000,
	opts = {
		use_wallust = true,
	},
	init = function()
		vim.cmd.colorscheme 'neopywal'
	end,
}
