local mason_null_ls = require 'mason-null-ls'
local null_ls = require 'null-ls'

mason_null_ls.setup(require 'opts.mason_null_ls')
null_ls.setup()
mason_null_ls.setup_handlers()
