local null_ls = require 'null-ls'

local opts = {
	sources = {
		null_ls.builtins.diagnostics.stylelint.with {
			extra_filetypes = { 'svelte' },
		},
		null_ls.builtins.formatting.stylelint.with {
			extra_filetypes = { 'svelte' },
		},
		null_ls.builtins.formatting.prettierd.with {
			filetypes = { 'css', 'scss', 'less' },
		},
		null_ls.builtins.formatting.swift_format,
	},
}

return opts
