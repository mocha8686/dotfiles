local lualine = require 'lualine'
local neopywal_lualine = require 'neopywal.theme.plugins.lualine'

neopywal_lualine.setup()

lualine.setup {
	options = {
		theme = 'neopywal',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = {
			{
				'filename',
				symbols = {
					readonly = '',
				},
			},
		},
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = {
			{
				'location',
				fmt = function(str)
					for l, c in string.gmatch(str, '(%d+):(%d+)') do
						return '' .. l .. ' ' .. c
					end
				end,
			},
		},
	},
}
