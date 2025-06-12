return {
	'L3MON4D3/LuaSnip',
	version = 'v2.*',
	build = 'make install_jsregexp',
	config = function()
		local snipmate = require 'luasnip.loaders.from_snipmate'
		snipmate.lazy_load()
	end,
}
