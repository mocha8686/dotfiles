local keys = {
	-- mini.files
	{
		'<C-t>',
		function()
			require('mini.files').open()
		end,
		desc = 'Open file browser',
	},

	-- mini.bufremove
	{
		'<leader>w',
		function()
			require('mini.bufremove').delete()
		end,
		desc = 'Delete buffer',
	},

	-- mini.animate
	{
		'<leader>ad',
		function()
			local config = require('mini.animate').config
			for key, _ in pairs(config) do
				config[key].enable = false
			end
		end,
		desc = 'Disable animations',
	},
	{
		'<leader>ai',
		function()
			local config = require('mini.animate').config
			for key, _ in pairs(config) do
				config[key].enable = true
			end
		end,
		desc = 'Enable animations',
	},
}

local function config()
	local text_editing = {
		'mini.ai',
		'mini.align',
		'mini.comment',
		'mini.move',
		'mini.operators',
		'mini.pairs',
		'mini.splitjoin',
		'mini.surround',
	}

	local workflow = {
		'mini.bufremove',
		{
			'mini.files',
			post = function()
				vim.api.nvim_create_autocmd('User', {
					pattern = 'MiniFilesActionRename',
					callback = function(event)
						Snacks.rename.on_rename_file(event.data.from, event.data.to)
					end,
				})
			end,
		},
	}

	local appearance = {
		'mini.animate',
		'mini.icons',
		'mini.indentscope',
	}

	--------------------------------------------------------------------------------

	local module_sets = {
		text_editing,
		workflow,
		appearance,
	}

	for _, module_set in ipairs(module_sets) do
		for _, module in ipairs(module_set) do
			if type(module) == 'string' then
				require(module).setup()
			elseif type(module) == 'table' then
				local module_name = module[1]
				local module_options = module['options']
				local post = module['post']

				require(module_name).setup(module_options)

				if post then
					post()
				end
			else
				error('Module type not recognized (type: ' .. type(module) .. ')')
			end
		end
	end

	vim.keymap.set({ 'n', 'v' }, 's', 's', {
		noremap = true,
		silent = true,
	})
end

return {
	'nvim-mini/mini.nvim',
	dependencies = {
		'folke/snacks.nvim',
	},
	version = false,
	event = 'VeryLazy',
	keys = keys,
	config = config,
}