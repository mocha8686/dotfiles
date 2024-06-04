local telescope = require 'telescope'

telescope.setup(require 'opts.telescope')

telescope.load_extension 'frecency'
telescope.load_extension 'ui-select'
telescope.load_extension 'file_browser'
