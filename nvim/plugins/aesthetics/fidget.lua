local util = require 'util'

return {
	'j-hui/fidget.nvim',
	init = util.lsp_lazy_load 'fidget.nvim',
	config = true,
}
