return {
	'junegunn/goyo.vim',
	dependencies = {
		'junegunn/limelight.vim',
	},
	cmd = 'Goyo',
	keys = {
		{ '<leader>fg', '<Cmd>Goyo<CR>', desc = 'Toggle Goyo' },
		{
			'<leader>fw',
			function()
				vim.cmd [[ Goyo ]]
				vim.cmd [[ Limelight!! ]]
			end,
			desc = 'Toggle writing mode',
		},
	},
	config = function()
		local augroup = vim.api.nvim_create_augroup('Goyo', { clear = true })

		vim.api.nvim_create_autocmd({ 'User' }, {
			group = augroup,
			pattern = 'GoyoEnter',
			callback = function()
				vim.opt.number = false
				vim.opt.relativenumber = false

				vim.keymap.set({ 'n', 'v' }, 'j', 'gj')
				vim.keymap.set({ 'n', 'v' }, 'k', 'gk')
				vim.keymap.set({ 'n', 'v' }, '0', 'g0')
				vim.keymap.set({ 'n', 'v' }, '$', 'g$')

				vim.opt.eventignore =
				{ 'BufEnter', 'FocusGained', 'InsertLeave', 'BufLeave', 'FocusLost', 'InsertEnter' }
				require('lualine').hide()
			end,
		})

		vim.api.nvim_create_autocmd({ 'User' }, {
			group = augroup,
			pattern = 'GoyoLeave',
			callback = function()
				vim.opt.number = true
				vim.opt.relativenumber = true

				vim.keymap.set({ 'n', 'v' }, 'j', 'j')
				vim.keymap.set({ 'n', 'v' }, 'k', 'k')
				vim.keymap.set({ 'n', 'v' }, '0', '0')
				vim.keymap.set({ 'n', 'v' }, '$', '$')

				vim.opt.eventignore = {}
				require('lualine').hide { unhide = true }
			end,
		})
	end,
}
