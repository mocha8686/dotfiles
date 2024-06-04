local null_ls = require 'null-ls'

local opts = {
	sources = {
		null_ls.builtins.formatting.prettierd.with {
			extra_filetypes = { 'svelte' },
		},
		null_ls.builtins.formatting.stylelint.with {
			extra_filetypes = { 'svelte' },
		},
	},
}

return opts
