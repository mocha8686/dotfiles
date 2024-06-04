local telescope = require 'telescope'

local theme = 'dropdown'

telescope.setup {
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

telescope.load_extension 'frecency'
telescope.load_extension 'ui-select'
telescope.load_extension 'file_browser'
