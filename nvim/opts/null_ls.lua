local null_ls = require 'null-ls'

local opts = {
	sources = {
		null_ls.builtins.formatting.stylelint.with {
			extra_filetypes = { 'astro', 'html' },
		},
	},
}

return opts
