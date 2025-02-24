local action_state = require 'telescope.actions.state'
local actions = require 'telescope.actions'
local conf = require('telescope.config').values
local dap = require 'dap'
local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'

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

dap.adapters.codelldb = {
	name = 'codelldb',
	type = 'executable',
	command = 'codelldb',
}

dap.adapters.delve = {
	name = 'delve',
	type = 'server',
	port = '${port}',
	executable = {
		command = 'dlv',
		args = { 'dap', '-l', '127.0.0.1:${port}' },
		detached = true,
	},
}

local function lldb_config(list_exes_program)
	local config = {
		name = 'Launch',
		type = 'codelldb',
		request = 'launch',
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
		program = function()
			return coroutine.create(function(co)
				local opts = {}
				pickers
					.new(opts, {
						prompt_title = 'Path to executable',
						finder = finders.new_oneshot_job(list_exes_program or {
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
								local entry = action_state.get_selected_entry()
								local exe = entry[1]
								coroutine.resume(co, exe)
							end)
							return true
						end,
					})
					:find()
			end)
		end,
	}

	return config
end

local delve_config = {
	name = 'Launch',
	type = 'delve',
	request = 'launch',
	program = '${file}',
}

dap.configurations.rust = { lldb_config() }
dap.configurations.cpp = { lldb_config() }
dap.configurations.zig = { lldb_config { 'zig', 'build', 'debug' } }
-- dap.configurations.zig = { lldb_config { 'fd', '--hidden', '--no-ignore', '--type', 'x' } }
dap.configurations.go = { delve_config }
