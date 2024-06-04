local M = {}

local function rpgbot()
	vim.cmd [[ 8TermExec cmd="pnpm dev" ]]
	vim.cmd [[ 9TermExec cmd="pnpm dev:db" ]]
end

M.keys = {
	defaults = {
		noremap = true,
		silent = true,
	},
	['vim'] = {
		{ '<C-h>',   '<Cmd>wincmd h<CR>', desc = 'Select window to the left',  mode = { 'n', 't' } },
		{ '<C-j>',   '<Cmd>wincmd j<CR>', desc = 'Select window below',        mode = { 'n', 't' } },
		{ '<C-k>',   '<Cmd>wincmd k<CR>', desc = 'Select window above',        mode = { 'n', 't' } },
		{ '<C-l>',   '<Cmd>wincmd l<CR>', desc = 'Select window to the right', mode = { 'n', 't' } },
		{ '<Tab>',   '<Cmd>bn<CR>',       desc = 'Select next tab' },
		{ '<S-Tab>', '<Cmd>bp<CR>',       desc = 'Select previous tab' },
		{
			'<ESC><ESC>',
			'<C-\\><C-N>',
			desc =
			'Exit terminal mode',
			mode = { 't' }
		},
	},
	['Comment.nvim'] = {
		{ 'gc', mode = { 'n', 'v' } },
	},
	['nvim-surround'] = {
		{ 'ys', mode = { 'n', 'v' } },
		{ 'ds', mode = { 'n', 'v' } },
		{ 'cs', mode = { 'n', 'v' } },
	},
	['vim-wordmotion'] = {
		{ 'w',          mode = { 'n', 'x', 'o' } },
		{ 'W',          mode = { 'n', 'x', 'o' } },
		{ 'b',          mode = { 'n', 'x', 'o' } },
		{ 'B',          mode = { 'n', 'x', 'o' } },
		{ 'e',          mode = { 'n', 'x', 'o' } },
		{ 'E',          mode = { 'n', 'x', 'o' } },
		{ 'ge',         mode = { 'n', 'x', 'o' } },
		{ 'gE',         mode = { 'n', 'x', 'o' } },
		{ 'aw',         mode = { 'x', 'o' } },
		{ 'aW',         mode = { 'x', 'o' } },
		{ 'iw',         mode = { 'x', 'o' } },
		{ 'iW',         mode = { 'x', 'o' } },
		{ '<C-R><C-W>', mode = 'c' },
	},
	['targets.vim'] = {
		{ 'i', mode = { 'x', 'o' } },
		{ 'I', mode = { 'x', 'o' } },
		{ 'a', mode = { 'x', 'o' } },
		{ 'A', mode = { 'x', 'o' } },
	},
	['vim-sayonara'] = {
		{ '<leader>d', '<Cmd>Sayonara!<CR>', desc = 'Delete the current buffer and close the window' },
		{ '<leader>c', '<Cmd>Sayonara<CR>',  desc = 'Delete the current buffer' },
	},
	['leap.nvim'] = {
		{ 'z', '<Plug>(leap-forward-x)',  mode = { 'n', 'x', 'o' } },
		{ 'Z', '<Plug>(leap-backward-x)', mode = { 'n', 'x', 'o' } },
	},
	['flit.nvim'] = {
		'f', 'F', 't', 'T'
	},
	['flash.nvim'] = {
		{ '<leader>fs', function() require('flash').jump() end,   mode = { 'n', 'x', 'o' }, desc = 'Flash' },
		{
			'<leader>fS',
			function() require('flash').treesitter() end,
			mode = { 'n', 'x', 'o' },
			desc =
			'Treesitter'
		},
		{ 'r',          function() require('flash').remote() end, mode = 'o',               desc = 'Remote' },
		{
			'R',
			function() require('flash').treesitter_search() end,
			mode = { 'x', 'o' },
			desc =
			'Treesitter search'
		},
		{ '<C-s>', function() require('flash').toggle() end, mode = { 'c' }, desc = 'Toggle' },
	},
	['telescope.nvim'] = function()
		local telescope = require 'telescope'
		local telescope_builtin = require 'telescope.builtin'

		local theme = 'dropdown'
		local picker_opts = { theme = theme, workspace = 'CWD' }

		local keys = {
			{
				'<C-t>',
				function() telescope.extensions.file_browser.file_browser(picker_opts) end,
				desc =
				'Open file browser'
			},
			{
				'<C-p>',
				function() telescope_builtin.find_files(picker_opts) end,
				desc =
				'Open file finder'
			},
			{
				'<leader>p',
				function() telescope_builtin.live_grep(picker_opts) end,
				desc =
				'Open live grep'
			},
		}

		return keys
	end,
	['nvim-lspconfig'] = function()
		local telescope_builtin = require 'telescope.builtin'
		local todo_comments = require 'todo-comments'

		return {
			{
				'K',
				vim.lsp.buf.hover,
				desc =
				'Display hover info',
			},
			{
				'<leader>lD',
				vim.lsp.buf.declaration,
				desc =
				'Jump to declaration',
			},
			{
				'<leader>ld',
				telescope_builtin.lsp_definitions,
				desc =
				'Jump to definition',
			},
			{
				'<leader>li',
				telescope_builtin.lsp_implementations,
				desc =
				'Show implementations',
			},
			{
				'<leader>lS',
				vim.lsp.buf.signature_help,
				desc =
				'Show signature info',
			},
			{
				'<leader>lr',
				telescope_builtin.lsp_references,
				desc =
				'Show references',
			},
			{
				'<leader>lR',
				vim.lsp.buf.rename,
				desc =
				'Rename symbol',
			},
			{
				'<leader>lA',
				vim.lsp.buf.code_action,
				desc =
				'Show code actions',
				mode = {
					'n', 'v' },
			},
			{
				'<leader>lf',
				function()
					vim.lsp.buf.format { async = true }
				end,
				desc = 'Format',
			},
			{
				']e',
				function() vim.diagnostic.goto_next { float = { scope = 'line' } } end,
				desc =
				'Next diagnostic',
			},
			{
				'[e',
				function() vim.diagnostic.goto_prev { float = { scope = 'line' } } end,
				desc =
				'Previous diagnostic',
			},
			{
				']t',
				function() todo_comments.jump_next() end,
				desc =
				'Next TODO',
			},
			{
				'[t',
				function() todo_comments.jump_prev() end,
				desc =
				'Previous TODO',
			},
		}
	end,
	['trouble.nvim'] = {
		{ '<leader>xx', '<Cmd>TroubleToggle<CR>',                       desc = 'Toggle Trouble' },
		{ '<leader>xw', '<Cmd>TroubleToggle workspace_diagnostics<CR>', desc = 'Workspace diagnostics' },
		{ '<leader>xd', '<Cmd>TroubleToggle document_diagnostics<CR>',  desc = 'Document diagnostics' },
		{ '<leader>xl', '<Cmd>TroubleToggle loclist<CR>',               desc = 'Location list' },
		{ '<leader>xq', '<Cmd>TroubleToggle quickfix<CR>',              desc = 'Quickfix' },
		{ '<leader>xt', '<Cmd>TodoTrouble<CR>',                         desc = 'TODOs' },
		{ '<leader>xr', '<Cmd>TroubleToggle lsp_references<CR>',        desc = 'References' },
	},
	['toggleterm.nvim'] = {
		{ '<leader>tt', function() end, desc = 'Toggle terminal' },
		{ '<leader>tr', rpgbot,         desc = 'Start RPGBot dev servers' },
	},
}

---Get keys for a plugin.
---@param plugin string Plugin to get keys of.
---@return string|function|table Plugin keys as a string, function, or table of LazyKeys.
M.get_plugin_keys = function(plugin)
	local plugin_keys = M.keys[plugin]

	if plugin_keys == nil then
		error('Keys not found for plugin `' .. plugin .. '`.')
	end

	if type(plugin_keys) == 'table' then
		local res = {}
		for _, key in ipairs(plugin_keys) do
			if type(key) == table then
				table.insert(res, vim.tbl_deep_extend('force', M.keys.defaults, key))
			else
				table.insert(res, key)
			end
		end
		return res
	elseif type(plugin_keys) == 'function' then
		-- return get_plugin_keys(plugin_keys())
		return plugin_keys
	elseif type(plugin_keys) == 'string' then
		return plugin_keys
	else
		error('Keys must be of type `string|function|table`.')
	end
end

---Map plugin keys.
---@param plugin string Plugin to map.
M.map_plugin_keys = function(plugin)
	local plugin_keys = M.get_plugin_keys(plugin)
	while type(plugin_keys) == 'function' do
		plugin_keys = plugin_keys()
	end
	if type(plugin_keys) ~= 'table' then
		error('key must be a table to map a key for plugin' .. plugin .. '.')
	end

	for _, key in ipairs(plugin_keys) do
		if key[2] == nil then
			error('`key[2]` must be defined to map a key for plugin ' .. plugin .. '.')
		end

		vim.keymap.set(key.mode or 'n', key[1], key[2], {
			nowait = key.nowait,
			silent = key.silent,
			script = key.script,
			expr = key.expr,
			unique = key.unique,
			noremap = key.noremap,
			desc = key.desc,
			callback = key.callback,
			replace_keycodes = key.replace_keycodes,
		})
	end
end

---Map plugin keys in a buffer.
---@param plugin string Plugin to map.
---@param buf integer Buffer to map in.
M.map_plugin_keys_buffer = function(plugin, buf)
	local plugin_keys = M.get_plugin_keys(plugin)
	while type(plugin_keys) == 'function' do
		plugin_keys = plugin_keys()
	end
	if type(plugin_keys) ~= 'table' then
		error('key must be a table to map a key for plugin' .. plugin .. '.')
	end

	for _, key in ipairs(plugin_keys) do
		if key[2] == nil then
			error('`key[2]` must be defined to map a key for plugin ' .. plugin .. '.')
		end

		vim.keymap.set(key.mode or 'n', key[1], key[2], {
			nowait = key.nowait,
			silent = key.silent,
			script = key.script,
			expr = key.expr,
			unique = key.unique,
			noremap = key.noremap,
			desc = key.desc,
			callback = key.callback,
			replace_keycodes = key.replace_keycodes,
			buffer = buf,
		})
	end
end

return M
