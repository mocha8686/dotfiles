local keys = require 'keys'

local opts = {
	direction = 'vertical',
	hide_numbers = true,
	insert_mappings = false,
	open_mapping = keys.get_plugin_keys 'toggleterm.nvim',
	persist_mode = false,
	persist_size = false,
	shade_terminals = false,
	size = vim.o.columns * 0.4,
	terminal_mappings = false,
}

return opts
