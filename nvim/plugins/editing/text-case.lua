return {
	'johmsalas/text-case.nvim',
	lazy = false,
	config = true,
	keys = {
		'gq',
		{ 'gq.', '<Cmd>TextCaseOpenTelescope<CR>', mode = { 'n', 'x' }, desc = 'Telescope' },
	},
	cmd = {
		'Subs',
		'TextCaseOpenTelescope',
		'TextCaseOpenTelescopeQuickChange',
		'TextCaseOpenTelescopeLSPChange',
		'TextCaseStartReplacingCommand',
	},
	opts = {
		prefix = 'gq',
	},
}
