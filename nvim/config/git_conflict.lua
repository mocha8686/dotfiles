local git_conflict = require 'git-conflict'

git_conflict.setup {
	highlights = {
		incoming = 'DiffDelete',
		current = 'DiffChange',
	},
}
