return {
	'akinsho/bufferline.nvim',
	lazy = false,
	version = '*',
	dependencies = 'nvim-tree/nvim-web-devicons',
	opts = {
		options = {
			diagnostics = 'nvim_lsp',
			diagnostics_indicator = function(count, level)
				local icon = level:match 'error' and ' ' or ' '
				return ' ' .. icon .. count
			end,
		},
	},
}
