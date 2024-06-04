local ccc = require 'ccc'

ccc.setup {
	inputs = {
		ccc.input.hsl,
		ccc.input.rgb,
		ccc.input.cmyk,
	},
	outputs = {
		ccc.output.css_hsl,
		ccc.output.hex_short,
		ccc.output.hex,
		ccc.output.css_rgb,
	},
	highlighter = {
		['auto-enable'] = true,
	},
}
