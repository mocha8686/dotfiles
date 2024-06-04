local dap = require 'dap'
local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local conf = require('telescope.config').values
local action_state = require 'telescope.actions.state'
local actions = require 'telescope.actions'

local hl = vim.api.nvim_set_hl
local sign_define = vim.fn.sign_define

hl(0, 'DapError', { ctermfg = 1, fg = 'Red' })
hl(0, 'DapBreakpointCondition', { fg = '#00f1f5' })
hl(0, 'DapLogPoint', { fg = '#d484ff' })
hl(0, 'DapStopped', { ctermfg = 4, fg = 'LightBlue' })
hl(0, 'DapBreakpoint', { fg = '#f70067' })

sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpointCondition' })
sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint' })
sign_define('DapStopped', { text = '', texthl = 'DapStopped' })
sign_define('DapBreakpointRejected', { text = '', texthl = 'DapError' })

local codelldb_port = '65472'
dap.adapters.codelldb = {
	name = 'codelldb',
	type = 'server',
	port = codelldb_port,
	executable = {
		command = 'codelldb',
		args = { '--port', codelldb_port },
	},
}

local lldb_config = {
	{
		name = 'Launch',
		type = 'codelldb',
		request = 'launch',
		program = function()
			return coroutine.create(function(coro)
				local opts = {}
				pickers
					.new(opts, {
						prompt_title = 'Path to executable',
						finder = finders.new_oneshot_job({
							'fd',
							'--unrestricted',
							'--type',
							'x',
							'--full-path',
							'(builddir|target/(debug|release))/[^/]+$',
						}, {}),
						sorter = conf.generic_sorter(opts),
						attach_mappings = function(buffer_number)
							actions.select_default:replace(function()
								actions.close(buffer_number)
								coroutine.resume(coro, action_state.get_selected_entry()[1])
							end)
							return true
						end,
					})
					:find()
			end)
		end,

		cwd = '${workspaceFolder}',
		stopOnEntry = false,
	},
}

dap.configurations.rust = lldb_config
dap.configurations.cpp = lldb_config
