local keys = require 'keys'
local util = require 'util'

local plugins = {
	-- Editing
	{
		{
			'andymass/vim-matchup',
			event = 'InsertEnter',
		},
		{
			'windwp/nvim-autopairs',
			event = 'InsertEnter',
			config = function()
				require 'config.nvim_autopairs'
			end,
		},
		{
			'numToStr/Comment.nvim',
			keys = keys.get_plugin_keys 'Comment.nvim',
			config = true,
		},
		{
			'kylechui/nvim-surround',
			dependencies = {
				'nvim-treesitter/nvim-treesitter',
				'nvim-treesitter/nvim-treesitter-textobjects',
			},
			keys = keys.get_plugin_keys 'nvim-surround',
			config = true,
		},
		{
			'sQVe/sort.nvim',
			cmd = 'Sort',
			config = true,
		},
		{
			'nvim-pack/nvim-spectre',
			dependencies = 'nvim-lua/plenary.nvim',
			config = true,
			keys = keys.get_plugin_keys 'nvim-spectre',
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
		{
			'Vonr/align.nvim',
			branch = 'v2',
			config = true,
			keys = keys.get_plugin_keys 'align.nvim',
		},
	},

	-- Git
	{
		'akinsho/git-conflict.nvim',
		version = '*',
		init = util.git_lazy_load 'git-conflict.nvim',
		config = function()
			require 'config.git_conflict'
		end,
	},

	-- LSP
	{
		{
			'L3MON4D3/LuaSnip',
			version = 'v2.*',
			build = 'make install_jsregexp',
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
				'folke/neoconf.nvim',
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
			'nvimtools/none-ls.nvim',
			dependencies = {
				'jay-babu/mason-null-ls.nvim',
				'neovim/nvim-lspconfig',
				'nvim-lua/plenary.nvim',
				'williamboman/mason.nvim',
			},
			config = function()
				require 'config.null_ls'
			end,
		},
		{
			'kosayoda/nvim-lightbulb',
			dependencies = 'neovim/nvim-lspconfig',
			event = 'VeryLazy',
			opts = require 'opts.lightbulb',
			config = function(_, opts)
				require('nvim-lightbulb').setup(opts)
				vim.fn.sign_define('LightBulbSign', { text = '󰌵' })
			end,
		},
		{
			'folke/lazydev.nvim',
			ft = 'lua',
			config = true,
		},
	},

	-- DAP
	{
		{
			'mfussenegger/nvim-dap',
			dependencies = 'nvim-telescope/telescope.nvim',
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
			opts = require 'opts.mason_nvim_dap',
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
			'chaoren/vim-wordmotion',
			keys = keys.get_plugin_keys 'vim-wordmotion',
		},
		{
			'wellle/targets.vim',
			keys = keys.get_plugin_keys 'targets.vim',
		},
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
			'mhinz/vim-sayonara',
			keys = keys.get_plugin_keys 'vim-sayonara',
		},
		{
			'nvim-focus/focus.nvim',
			event = 'VeryLazy',
			version = false,
			config = true,
		},
		{
			'akinsho/toggleterm.nvim',
			version = '*',
			keys = keys.get_plugin_keys 'toggleterm.nvim',
			opts = require 'opts.toggleterm',
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
			opts = require 'opts.nvim_web_devicons',
		},
		{
			'lewis6991/gitsigns.nvim',
			init = util.git_lazy_load 'gitsigns.nvim',
			opts = require 'opts.gitsigns',
		},
		{
			'nvim-lualine/lualine.nvim',
			lazy = false,
			dependencies = 'nvim-tree/nvim-web-devicons',
			opts = require 'opts.lualine',
		},
		{
			'akinsho/bufferline.nvim',
			lazy = false,
			version = '*',
			dependencies = 'nvim-tree/nvim-web-devicons',
			opts = require 'opts.bufferline',
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
			opts = require 'opts.which_key',
			config = true,
		},
	},

	-- CSS
	{
		'luckasRanarison/tailwind-tools.nvim',
		ft = {
			'html',
			'javascript',
			'javascriptreact',
			'typescript',
			'typescriptreact',
		},
		opts = require 'opts.tailwind-tools',
	},

	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		dependencies = {
			'RRethy/nvim-treesitter-endwise',
			'nvim-treesitter/nvim-treesitter-refactor',
			'nvim-treesitter/nvim-treesitter-textobjects',
			'windwp/nvim-ts-autotag',
		},
		cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
		init = util.lazy_load 'nvim-treesitter',
		opts = require 'opts.treesitter',
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end,
	},

	-- Aesthetics
	{
		{
			'romainl/vim-cool',
			keys = '/',
		},
		{
			'AlphaTechnolog/pywal.nvim',
			name = 'pywal',
			lazy = false,
			priority = 1000,
			config = true,
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
			},
			config = function()
				require 'config.ccc'
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
	},
}

return plugins
