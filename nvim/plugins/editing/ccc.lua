return {
	'uga-rosa/ccc.nvim',
	keys = {
		{ '<leader>ch', '<Cmd>CccHighlighterToggle<CR>', desc = 'Highlight colors' },
		{ '<leader>cp', '<Cmd>CccPick<CR>', desc = 'Open color picker' },
		{ '<leader>cc', '<Cmd>CccConvert<CR>', desc = 'Convert color to other formats' },
	},
	ft = {
		'html',
		'css',
		'scss',
		'sass',
		'javascript',
		'javascriptreact',
		'typescript',
		'typescriptreact',
		'markdown',
		'mdx',
	},
	opts = function()
		local ccc = require 'ccc'

		return {
			inputs = {
				ccc.input.oklch,
				ccc.input.hsl,
				ccc.input.rgb,
				ccc.input.cmyk,
			},
			outputs = {
				ccc.output.css_oklch,
				ccc.output.css_hsl,
				ccc.output.hex_short,
				ccc.output.hex,
				ccc.output.css_rgb,
			},
			highlighter = {
				auto_enable = true,
				filetypes = {
					'html',
					'css',
					'scss',
					'sass',
					'javascript',
					'javascriptreact',
					'typescript',
					'typescriptreact',
					'markdown',
					'mdx',
				},
			},
		}
	end,
}
