local keys = require '../keys'

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
	{ 'mini.bufremove', keys = true },
	{
		'mini.files',
		keys = true,
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
	{
		'mini.animate',
		keys = true,
	},
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
			local use_keys = module['keys']
			local module_options = module['options']
			local post = module['post']

			require(module_name).setup(module_options)
			if use_keys then
				keys.map_plugin_keys(module_name)
			end

			if post then
				post()
			end
		else
			error('Module type not recognized (type: ' .. type(module) .. ')')
		end
	end
end
