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
			config = true,
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
	},

	-- Git
	{
		'akinsho/git-conflict.nvim',
		version = '*',
		init = util.git_lazy_load 'git-conflict.nvim',
		config = true,
	},

	-- LSP
	{
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
				'folke/neodev.nvim',
				'hrsh7th/nvim-cmp',
				'jose-elias-alvarez/null-ls.nvim',
				'nvim-telescope/telescope.nvim',
				'ray-x/lsp_signature.nvim',
				'rcarriga/nvim-notify',
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
			'jose-elias-alvarez/null-ls.nvim',
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
			end
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
			'mhinz/vim-sayonara',
			keys = keys.get_plugin_keys 'vim-sayonara',
		},
		{
			'ggandor/leap.nvim',
			dependencies = 'tpope/vim-repeat',
			keys = keys.get_plugin_keys 'leap.nvim',
		},
		{
			'ggandor/flit.nvim',
			keys = keys.get_plugin_keys 'flit.nvim',
			dependencies = 'ggandor/leap.nvim',
			opts = require 'opts.flit',
		},
		{
			'simeji/winresizer',
			keys = '<C-e>',
			cmd = 'WinResizerStartResize',
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
			dependencies = 'kkharji/sqlite.lua',
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
			version = 'v3.*',
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
			init = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
			end,
			config = function()
				require 'config.which_key'
			end,
		},
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
			require 'nvim-treesitter.configs'.setup(opts)
		end
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
			'norcalli/nvim-colorizer.lua',
			ft = {
				'javascript',
				'typescript',
				'javascriptreact',
				'typescriptreact',
				'css',
				'scss',
				'sass',
				'html',
			},
			opts = require 'opts.colorizer',
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
