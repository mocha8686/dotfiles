local dap = require 'dap'

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
	type = 'server',
	port = codelldb_port,
	executable = {
		command = 'codelldb',
		args = { '--port', codelldb_port },
	},
	name = 'codelldb',
}

dap.configurations.rust = {
	{
		name = 'Launch',
		type = 'codelldb',
		request = 'launch',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
	},
}
