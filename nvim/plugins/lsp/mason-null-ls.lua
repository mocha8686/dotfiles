local function opts()
	local mason_null_ls = require 'mason-null-ls'

	return {
		automatic_installation = true,
		handlers = {
			stylelint = function(source_name, methods)
				if vim.fs.root(0, { 'stylelint.config.js' }) then
					mason_null_ls.default_setup(source_name, methods)
				end
			end,
			prettierd = function(source_name, methods)
				if vim.fs.root(0, { '.prettierrc' }) then
					mason_null_ls.default_setup(source_name, methods)
				end
			end,
		},
	}
end

return {
	'jay-babu/mason-null-ls.nvim',
	opts = opts,
}
