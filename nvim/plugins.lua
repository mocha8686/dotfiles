local keys = require 'keys'
local util = require 'util'

local plugins = {
	{
		'echasnovski/mini.nvim',
		dependencies = {
			'folke/snacks.nvim',
		},
		version = false,
		event = 'VeryLazy',
		config = function()
			require 'config.mini_nvim'
		end,
	},

	{
		'folke/snacks.nvim',
		lazy = false,
		priority = 100,
		opts = function()
			return require 'opts.snacks'
		end,
	},

	-- Editing
	{
		{
			'andymass/vim-matchup',
			event = 'InsertEnter',
		},
		{
			'nvim-pack/nvim-spectre',
			dependencies = 'nvim-lua/plenary.nvim',
			opts = function()
				return require 'opts.spectre'
			end,
			keys = keys.get_plugin_keys 'nvim-spectre',
			build = './build.sh',
		},
		{
			'stevearc/dressing.nvim',
			lazy = false,
			config = true,
		},
		{
			'johmsalas/text-case.nvim',
			lazy = false,
			config = true,
			keys = keys.get_plugin_keys 'text-case.nvim',
			cmd = {
				'Subs',
				'TextCaseOpenTelescope',
				'TextCaseOpenTelescopeQuickChange',
				'TextCaseOpenTelescopeLSPChange',
				'TextCaseStartReplacingCommand',
			},
			opts = function()
				return require 'opts.text_case'
			end,
		},
		-- {
		-- 	'dhruvasagar/vim-table-mode',
		-- 	ft = {
		-- 		'markdown',
		-- 		'text',
		-- 		'tex',
		-- 		'plaintex',
		-- 		'norg',
		-- 	},
		-- },
		-- {
		-- 	'gaoDean/autolist.nvim',
		-- 	-- ft = {
		-- 	-- 	'markdown',
		-- 	-- 	'text',
		-- 	-- 	'tex',
		-- 	-- 	'plaintex',
		-- 	-- 	'norg',
		-- 	-- },
		-- 	event = 'InsertEnter',
		-- 	priority = 25,
		-- 	config = true,
		-- 	keys = keys.get_plugin_keys 'autolist.nvim',
		-- },
	},

	-- Git
	{
		'akinsho/git-conflict.nvim',
		version = '*',
		init = util.git_lazy_load 'git-conflict.nvim',
		opts = function()
			return require 'opts.git_conflict'
		end,
	},

	-- LSP
	{
		{
			'L3MON4D3/LuaSnip',
			version = 'v2.*',
			build = 'make install_jsregexp',
			config = function()
				require 'config.luasnip'
			end,
		},
		{
			'hrsh7th/nvim-cmp',
			dependencies = {
				'L3MON4D3/LuaSnip',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-cmdline',
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-nvim-lua',
				'hrsh7th/cmp-path',
				'lukas-reineke/cmp-under-comparator',
				'onsails/lspkind.nvim',
				'saadparwaiz1/cmp_luasnip',
			},
			event = 'InsertEnter',
			config = function()
				require 'config.cmp'
			end,
		},
		{
			'neovim/nvim-lspconfig',
			dependencies = {
				'hrsh7th/nvim-cmp',
				'lvimuser/lsp-inlayhints.nvim',
				'nvim-telescope/telescope.nvim',
				'nvimtools/none-ls.nvim',
				'ray-x/lsp_signature.nvim',
				'williamboman/mason-lspconfig.nvim',
				'williamboman/mason.nvim',
			},
			event = 'InsertEnter',
			init = util.lazy_load 'nvim-lspconfig',
			config = function()
				require 'config.lspconfig'
			end,
		},
		{
			'jay-babu/mason-null-ls.nvim',
			opts = function()
				return require 'opts.mason_null_ls'
			end,
		},
		{
			'nvimtools/none-ls.nvim',
			dependencies = {
				'jay-babu/mason-null-ls.nvim',
				'neovim/nvim-lspconfig',
				'nvim-lua/plenary.nvim',
				'williamboman/mason.nvim',
			},
			opts = function()
				return require 'opts.null_ls'
			end,
		},
		{
			'kosayoda/nvim-lightbulb',
			dependencies = 'neovim/nvim-lspconfig',
			event = 'VeryLazy',
			opts = function()
				return require 'opts.lightbulb'
			end,
			config = true,
		},
		{
			'folke/lazydev.nvim',
			ft = 'lua',
			config = true,
		},
		{
			'danymat/neogen',
			config = true,
			keys = keys.get_plugin_keys 'neogen',
		},
	},

	-- DAP
	{
		{
			'mfussenegger/nvim-dap',
			dependencies = { 'nvim-telescope/telescope.nvim' },
			keys = keys.get_plugin_keys 'nvim-dap',
			config = function()
				require 'config.nvim_dap'
			end,
		},
		{
			'jay-babu/mason-nvim-dap.nvim',
			dependencies = {
				'williamboman/mason.nvim',
				'mfussenegger/nvim-dap',
			},
			cmd = { 'DapInstall', 'DapUninstall' },
			opts = function()
				return require 'opts.mason_nvim_dap'
			end,
		},
		{
			'rcarriga/nvim-dap-ui',
			dependencies = {
				'mfussenegger/nvim-dap',
				'nvim-neotest/nvim-nio',
			},
			keys = keys.get_plugin_keys 'nvim-dap-ui',
			config = function()
				require 'config.nvim_dap_ui'
			end,
		},
	},

	-- Navigation
	{
		{
			'folke/flash.nvim',
			event = 'VeryLazy',
			config = true,
			keys = keys.get_plugin_keys 'flash.nvim',
		},
	},

	-- Buffer, window, and tab management
	{
		{
			'nvim-focus/focus.nvim',
			event = 'VeryLazy',
			version = false,
			init = function()
				require 'init.focus-nvim'
			end,
			config = true,
		},
		{
			'akinsho/toggleterm.nvim',
			version = '*',
			keys = keys.get_plugin_keys 'toggleterm.nvim',
			opts = function()
				return require 'opts.toggleterm'
			end,
		},
	},

	-- Telescope
	{
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build =
			'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
		},
		{
			'nvim-telescope/telescope-frecency.nvim',
		},
		{
			'nvim-telescope/telescope.nvim',
			dependencies = {
				'nvim-lua/plenary.nvim',
				'nvim-telescope/telescope-file-browser.nvim',
				'nvim-telescope/telescope-fzf-native.nvim',
				'nvim-telescope/telescope-ui-select.nvim',
			},
			version = '0.1.x',
			keys = keys.get_plugin_keys 'telescope.nvim',
			cmd = 'Telescope',
			config = function()
				require 'config.telescope'
			end,
		},
	},

	-- Information
	{
		{
			'nvim-tree/nvim-web-devicons',
			opts = function()
				return require 'opts.nvim_web_devicons'
			end,
		},
		{
			'lewis6991/gitsigns.nvim',
			init = util.git_lazy_load 'gitsigns.nvim',
			opts = function()
				return require 'opts.gitsigns'
			end,
		},
		{
			'nvim-lualine/lualine.nvim',
			lazy = false,
			dependencies = {
				'nvim-tree/nvim-web-devicons',
				'RedsXDD/neopywal.nvim',
			},
			opts = function()
				return require 'opts.lualine'
			end,
		},
		{
			'akinsho/bufferline.nvim',
			lazy = false,
			version = '*',
			dependencies = 'nvim-tree/nvim-web-devicons',
			opts = function()
				return require 'opts.bufferline'
			end,
		},
		{
			'j-hui/fidget.nvim',
			init = util.lsp_lazy_load 'fidget.nvim',
			config = true,
		},
		{
			'folke/trouble.nvim',
			dependencies = {
				'neovim/nvim-lspconfig',
				'nvim-tree/nvim-web-devicons',
			},
			init = util.lsp_lazy_load 'trouble.nvim',
			keys = keys.get_plugin_keys 'trouble.nvim',
			config = true,
		},
		{
			'folke/which-key.nvim',
			event = 'VeryLazy',
			opts = function()
				return require 'opts.which_key'
			end,
			config = true,
		},
	},

	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		dependencies = {
			'RRethy/nvim-treesitter-endwise',
			'nvim-treesitter/nvim-treesitter-refactor',
			'windwp/nvim-ts-autotag',
		},
		cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
		init = util.lazy_load 'nvim-treesitter',
		opts = function()
			return require 'opts.treesitter'
		end,
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end,
	},
	{
		'davidmh/mdx.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = true,
		lazy = false,
	},

	-- Aesthetics
	{
		{
			'romainl/vim-cool',
			keys = '/',
		},
		{
			'RedsXDD/neopywal.nvim',
			name = 'neopywal',
			tag = 'v2.6.0',
			lazy = false,
			priority = 1000,
			config = function()
				require 'config.neopywal'
			end,
		},
		{
			'uga-rosa/ccc.nvim',
			keys = keys.get_plugin_keys 'ccc.nvim',
			ft = {
				'html',
				'css',
				'scss',
				'sass',
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
				'markdown',
				'mdx',
			},
			opts = function()
				return require 'opts.ccc'
			end,
		},
		{
			'folke/todo-comments.nvim',
			dependencies = {
				'folke/trouble.nvim',
				'nvim-lua/plenary.nvim',
				'nvim-telescope/telescope.nvim',
			},
			event = 'VeryLazy',
			config = true,
		},
		{
			'rcarriga/nvim-notify',
			event = 'VeryLazy',
			config = function()
				require 'config.nvim_notify'
			end,
		},
	},
}

return plugins
