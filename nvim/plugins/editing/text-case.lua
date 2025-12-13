return {
	'johmsalas/text-case.nvim',
	lazy = false,
	config = true,
	keys = {
		'gt',
		{ 'gt.', '<Cmd>TextCaseOpenTelescope<CR>', mode = { 'n', 'x' }, desc = 'Telescope' },
	},
	cmd = {
		'Subs',
		'TextCaseOpenTelescope',
		'TextCaseOpenTelescopeQuickChange',
		'TextCaseOpenTelescopeLSPChange',
		'TextCaseStartReplacingCommand',
	},
	opts = {
		prefix = 'gt',
	},
}
