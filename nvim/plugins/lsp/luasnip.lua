return {
	'L3MON4D3/LuaSnip',
	version = 'v2.*',
	build = 'make install_jsregexp',
	config = function()
		local luasnip = require 'luasnip'
		local snipmate = require 'luasnip.loaders.from_snipmate'

		luasnip.setup {
			enable_autosnippets = true,
		}
		snipmate.lazy_load()
	end,
}
