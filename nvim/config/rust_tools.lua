local keys = require 'keys'
local rt = require 'rust-tools'

local extension_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb'
local this_os = vim.loop.os_uname().sysname

-- The path in windows is different
if this_os:find 'Windows' then
	codelldb_path = extension_path .. 'adapter\\codelldb.exe'
	liblldb_path = extension_path .. 'lldb\\bin\\liblldb.dll'
else
	-- The liblldb extension is .so for linux and .dylib for macOS
	liblldb_path = liblldb_path .. (this_os == 'Linux' and '.so' or '.dylib')
end

rt.setup {
	tools = {
		executor = require('rust-tools.executors').toggleterm,
		hover_actions = {
			auto_focus = true,
		},
	},
	server = {
		on_attach = function(_, buf)
			keys.map_plugin_keys_buffer('nvim-lspconfig', buf)
			keys.map_plugin_keys_buffer('rust-tools', buf)
		end,
	},
	dap = {
		adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
	},
}
