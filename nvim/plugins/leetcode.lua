return {
	'kawre/leetcode.nvim',
	dependencies = {
		'nvim-telescope/telescope.nvim',
		-- "ibhagwan/fzf-lua",
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
	},
	opts = {},
	keys = {
		{ '<leader>vv',    '<Cmd>Leet<CR>',         desc = 'Open menu' },
		{ "<leader>v'",    '<Cmd>Leet run<CR>',     desc = 'Run solution' },
		{ '<leader>v<CR>', '<Cmd>Leet submit<CR>',  desc = 'Submit solution' },
		{ '<leader>vt',    '<Cmd>Leet tabs<CR>',    desc = 'View Leet tabs' },
		{ '<leader>vd',    '<Cmd>Leet desc<CR>',    desc = 'View question description' },
		{ '<leader>vi',    '<Cmd>Leet info<CR>',    desc = 'View question info' },
		{ '<leader>vc',    '<Cmd>Leet console<CR>', desc = 'Open console' },
		{ '<leader>vl',    '<Cmd>Leet lang<CR>',    desc = 'Change language' },
		{ '<leader>vy',    '<Cmd>Leet daily<CR>',   desc = 'Daily problem' },
		{ '<leader>vr',    '<Cmd>Leet random<CR>',  desc = 'Random problem' },
	},
	cmd = 'Leet',
}
