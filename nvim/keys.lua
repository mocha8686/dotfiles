local M = {}

local function create_terminal_callback(split, vertical)
	return function()
		if split then
			if vertical then
				vim.cmd [[ vsplit ]]
			else
				vim.cmd [[ 15split ]]
			end
		end

		vim.cmd [[ term ]]

		vim.opt.number = false
		vim.opt.relativenumber = false

		vim.cmd [[ startinsert ]]
	end
end

M.keys = {
	defaults = {
		noremap = true,
		silent = true,
	},
	['vim'] = {
		{ '<C-h>',      '<C-w>h' },
		{ '<C-j>',      '<C-w>j' },
		{ '<C-k>',      '<C-w>k' },
		{ '<C-l>',      '<C-w>l' },
		{ '<Tab>',      '<Cmd>bn<CR>' },
		{ '<S-Tab>',    '<Cmd>bp<CR>' },
		{ '<leader>tt', create_terminal_callback(true) },
		{ '<leader>th', create_terminal_callback(true, true) },
		{ '<leader>to', create_terminal_callback() },
		{ '<ESC><ESC>', '<C-\\><C-N>',                       mode = { 't' } },
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
		{ '<leader>d', '<Cmd>Sayonara!<CR>' },
		{ '<leader>c', '<Cmd>Sayonara<CR>' },
	},
	['leap.nvim'] = {
		{ 'z', '<Plug>(leap-forward-x)',  mode = { 'n', 'x', 'o' } },
		{ 'Z', '<Plug>(leap-backward-x)', mode = { 'n', 'x', 'o' } },
	},
	['flit.nvim'] = {
		'f', 'F', 't', 'T'
	},
	['telescope.nvim'] = function()
		local telescope = require 'telescope'
		local telescope_builtin = require 'telescope.builtin'

		local theme = 'dropdown'
		local picker_opts = { theme = theme, workspace = 'CWD' }

		local keys = {
			{ '<C-t>',     function() telescope.extensions.file_browser.file_browser(picker_opts) end },
			{ '<C-p>',     function() telescope_builtin.find_files(picker_opts) end },
			{ '<leader>p', function() telescope_builtin.live_grep(picker_opts) end },
		}

		return keys
	end,
	['nvim-lspconfig'] = function()
		local telescope_builtin = require 'telescope.builtin'
		local todo_comments = require 'todo-comments'

		return {
			{ 'K',          vim.lsp.buf.hover },
			{ '<leader>lD', vim.lsp.buf.declaration },
			{ '<leader>ld', telescope_builtin.lsp_definitions },
			{ '<leader>li', telescope_builtin.lsp_implementations },
			{ '<leader>lS', vim.lsp.buf.signature_help },
			{ '<leader>lr', telescope_builtin.lsp_references },
			{ '<leader>lR', vim.lsp.buf.rename },
			{ '<leader>lA', vim.lsp.buf.code_action,                                               mode = { 'n', 'v' } },
			{ ']e',         function() vim.diagnostic.goto_next { float = { scope = 'line' } } end },
			{ '[e',         function() vim.diagnostic.goto_prev { float = { scope = 'line' } } end },
			{ ']t',         function() todo_comments.jump_next() end },
			{ '[t',         function() todo_comments.jump_prev() end },
		}
	end,
	['trouble.nvim'] = {
		{ '<leader>xx', '<Cmd>TroubleToggle<CR>' },
		{ '<leader>xw', '<Cmd>TroubleToggle workspace_diagnostics<CR>' },
		{ '<leader>xd', '<Cmd>TroubleToggle document_diagnostics<CR>' },
		{ '<leader>xl', '<Cmd>TroubleToggle loclist<CR>' },
		{ '<leader>xq', '<Cmd>TroubleToggle quickfix<CR>' },
		{ '<leader>xt', '<Cmd>TodoTrouble<CR>' },
		{ '<leader>xr', '<Cmd>TroubleToggle lsp_references<CR>' },
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
