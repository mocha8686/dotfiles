local default_theme = 'dropdown'

local function get_keys()
	local picker_opts = { theme = default_theme, workspace = 'CWD' }

	local keys = {
		{
			'<C-p>',
			function()
				require('telescope.builtin').find_files(picker_opts)
			end,
			desc = 'Open file finder',
		},
		{
			'<leader>p',
			function()
				require('telescope.builtin').live_grep(picker_opts)
			end,
			desc = 'Open live grep',
		},
	}

	return keys
end

return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-file-browser.nvim',
		'nvim-telescope/telescope-fzf-native.nvim',
		'nvim-telescope/telescope-ui-select.nvim',
	},
	version = '0.1.x',
	keys = get_keys(),
	cmd = 'Telescope',
	config = function()
		local telescope = require 'telescope'

		telescope.setup {
			pickers = {
				find_files = {
					theme = default_theme,
				},
				live_grep = {
					theme = default_theme,
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
	end,
}
