local keys = require 'keys'

local opts = {
	open_mapping = keys.get_plugin_keys 'toggleterm.nvim',
	hide_numbers = true,
	insert_mappings = false,
	terminal_mappings = false,
	shade_terminals = false,
	direction = 'vertical',
	size = vim.o.columns * 0.4,
	persist_mode = false,
}

return opts
