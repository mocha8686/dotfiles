local open_mapping = '<leader>tr'

return {
	'akinsho/toggleterm.nvim',
	version = '*',
	keys = {
		{ open_mapping, function() end, desc = 'Toggle terminal' },
		{ "<C-'>",      '<C-\\><C-n>',  mode = { 't' },          desc = 'Exit to normal mode' },
	},
	opts = {
		direction = 'vertical',
		hide_numbers = true,
		insert_mappings = false,
		open_mapping = open_mapping,
		persist_mode = false,
		persist_size = false,
		shade_terminals = false,
		size = vim.o.columns * 0.4,
		terminal_mappings = false,
	},
}
