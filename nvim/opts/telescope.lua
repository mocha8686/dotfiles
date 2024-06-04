local theme = 'dropdown'

local opts = {
	pickers = {
		find_files = {
			theme = theme,
		},
		live_grep = {
			theme = theme,
		},
	},
	extensions = {
		['ui-select'] = {
			require('telescope.themes').get_cursor(),
		},
		file_browser = {
			theme = 'ivy',
			hijack_netrw = true,
		},
		frecency = {
			default_workspace = 'CWD',
		},
	},
}

return opts
