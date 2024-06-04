local plugins = {
	-- Editing
	{
		{
			'andymass/vim-matchup',
			lazy = false,
		},
		{
			'windwp/nvim-autopairs',
			lazy = false,
			config = true,
		},
		{
			'numToStr/Comment.nvim',
			lazy = false,
			config = true,
		},
		{
			'kylechui/nvim-surround',
			dependencies = {
				'nvim-treesitter/nvim-treesitter',
				'nvim-treesitter/nvim-treesitter-textobjects',
			},
			keys = {
				'ys',
				'ds',
				'cs',
			},
			config = true,
		},
	},

	-- Git
	{
		'akinsho/git-conflict.nvim',
		lazy = false,
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
				'hrsh7th/cmp-nvim-lsp-document-symbol',
				'hrsh7th/cmp-nvim-lsp-signature-help',
				'hrsh7th/cmp-nvim-lua',
				'hrsh7th/cmp-path',
				'lukas-reineke/cmp-under-comparator',
				'onsails/lspkind.nvim',
				'saadparwaiz1/cmp_luasnip',
			},
			lazy = false,
			config = function()
				local cmp = require 'cmp'
				local luasnip = require 'luasnip'

				cmp.setup {
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						['<C-d>'] = cmp.mapping.scroll_docs(-4),
						['<C-f>'] = cmp.mapping.scroll_docs(4),
						['<C-Space>'] = cmp.mapping.complete(),
						['<CR>'] = cmp.mapping.confirm {
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						},
						['<Tab>'] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { 'i', 's' }),
						['<S-Tab>'] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { 'i', 's' }),
					}),
					sources = {
						{ name = 'nvim_lsp' },
						{ name = 'luasnip' },
					},
				}
			end,
		},
		{
			'neovim/nvim-lspconfig',
			dependencies = {
				'folke/todo-comments.nvim',
				'folke/trouble.nvim',
				'hrsh7th/nvim-cmp',
				'nvim-telescope/telescope.nvim',
				'ray-x/lsp_signature.nvim',
				'rcarriga/nvim-notify',
				'williamboman/mason.nvim',
			},
			lazy = false,
			config = function()
				require('mason').setup()

				local cmp_nvim_lsp = require 'cmp_nvim_lsp'
				local lsp_signature = require 'lsp_signature'
				local lspconfig = require 'lspconfig'
				local notify = require 'notify'.notify
				local todo_comments = require 'todo-comments'
				local trouble = require 'trouble'

				local map = vim.keymap.set
				local sign_define = vim.fn.sign_define

				local severity = {
					'error',
					'warn',
					'info',
					'hint',
				}

				vim.lsp.handlers['window/showMessage'] = function(err, method, params, client_id)
					notify(method.message, severity[params.type])
				end

				sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
				sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
				sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
				sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

				local lsp_signature_opts = { bind = true, handler_opts = { border = 'single' } }

				local function on_attach(client, buf)
					lsp_signature.on_attach(lsp_signature_opts, buf)

					local telescope = require 'telescope'
					local telescope_builtin = require 'telescope.builtin'
					local opts = { silent = true, remap = true, buffer = buf }

					map('n', 'gD', vim.lsp.buf.declaration, opts)
					map('n', 'gd', telescope_builtin.lsp_definitions, opts)
					map('n', 'K', vim.lsp.buf.hover, opts)
					map('n', 'gi', telescope_builtin.lsp_implementations, opts)
					map('n', 'gS', vim.lsp.buf.signature_help, opts)
					map('n', 'gr', telescope_builtin.lsp_references, opts)
					map({ 'n', 'v' }, 'gA', vim.lsp.buf.code_action, opts)
					map('n', ']e', function() vim.diagnostic.goto_next { float = {scope = "line"} } end, opts)
					map('n', '[e', function() vim.diagnostic.goto_prev { float = {scope = "line"} } end, opts)

					map('n', '<leader>xx', '<Cmd>TroubleToggle<CR>', opts)
					map('n', '<leader>xw', '<Cmd>TroubleToggle workspace_diagnostics<CR>', opts)
					map('n', '<leader>xd', '<Cmd>TroubleToggle document_diagnostics<CR>', opts)
					map('n', '<leader>xl', '<Cmd>TroubleToggle loclist<CR>', opts)
					map('n', '<leader>xq', '<Cmd>TroubleToggle quickfix<CR>', opts)
					map('n', '<leader>xt', '<Cmd>TodoTrouble<CR>', opts)
					map('n', 'gR', '<Cmd>TroubleToggle lsp_references<CR>', opts)
					map('n', ']t', function() todo_comments.jump_next() end, opts)
					map('n', '[t', function() todo_comments.jump_prev() end, opts)

					if client.server_capabilities.documentFormattingProvider then
						vim.cmd [[ autocmd BufWritePre <buffer> lua vim.lsp.buf.format() ]]
					end

					if client.server_capabilities.documentHighlightProvider then
						vim.cmd [[ augroup lsp_aucmds ]]
						vim.cmd [[ autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight() ]]
						vim.cmd [[ autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references() ]]
						vim.cmd [[ augroup END ]]
					end
				end

				local servers = {
					'bashls',
					'clangd',
					'cmake',
					'cssls',
					'dockerls',
					'emmet_ls',
					'eslint',
					'html',
					'jsonls',
					'marksman',
					'pyright',
					'rust_analyzer',
					'svelte',
					'texlab',
					'tsserver',
				}

				local capabilities = cmp_nvim_lsp.default_capabilities()

				lsp_signature.setup(lsp_signature_opts)
				todo_comments.setup()
				trouble.setup()
				for _, lsp in ipairs(servers) do
					lspconfig[lsp].setup {
						on_attach = on_attach,
						capabilities = capabilities,
					}
				end
			end,
		},
		{
			'kosayoda/nvim-lightbulb',
			dependencies = 'neovim/nvim-lspconfig',
			lazy = false,
			opts = {
				autocmd = {
					enabled = true,
				},
			},
		},
	},

	-- Navigation
	{
		{
			'chaoren/vim-wordmotion',
			lazy = false,
		},
		{
			'wellle/targets.vim',
			lazy = false,
		},
		{
			'mhinz/vim-sayonara',
			keys = {
				'<leader>d',
				'<leader>c',
			},
			config = function()
				local map = vim.keymap.set
				local opts = { silent = true, remap = true }
				map('n', '<leader>d', '<Cmd>Sayonara!<CR>', opts)
				map('n', '<leader>c', '<Cmd>Sayonara<CR>', opts)
			end
		},
		{
			'ggandor/leap.nvim',
			dependencies = 'tpope/vim-repeat',
			keys = { 'z', 'Z' },
			config = function()
				local map = vim.keymap.set
				local opts = { remap = true }
				map({ 'n', 'x', 'o' }, 'z', '<Plug>(leap-forward-x)', opts)
				map({ 'n', 'x', 'o' }, 'Z', '<Plug>(leap-backward-x)', opts)
			end,
		},
		{
			'ggandor/flit.nvim', -- TODO: read
			keys = { 'f', 'F', 't', 'T' },
			dependencies = 'ggandor/leap.nvim',
			opts = {
				labeled_modes = 'nv',
			},
		},
	},

	-- Telescope
	{
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			lazy = false,
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
		},
		{
			'nvim-telescope/telescope-frecency.nvim',
			lazy = false,
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
			lazy = false,
			config = function()
				local telescope = require 'telescope'
				local telescope_builtin = require 'telescope.builtin'

				local theme = 'dropdown'

				local map = vim.keymap.set
				local opts = { silent = true, remap = true }
				local picker_opts = { theme = theme, workspace = 'CWD' }

				map('n', '<C-t>', function() telescope.extensions.file_browser.file_browser(picker_opts) end, opts)
				map('n', '<C-p>', function() telescope_builtin.find_files(picker_opts) end, opts)
				map('n', '<leader>p', function() telescope_builtin.live_grep(picker_opts) end, opts)

				telescope.setup {
					pickers = {
						find_files = {
							theme = theme,
						},
						live_grep = {
							theme = theme,
						},
					},
					extensions = {
						['ui-select'] = {
							require('telescope.themes').get_cursor(),
						},
						file_browser = { -- TODO: read
							theme = 'ivy',
							hijack_netrw = true,
						},
						frecency = {
							default_workspace = 'CWD',
						},
					},
				}

				telescope.load_extension 'frecency'
				telescope.load_extension 'ui-select'
				telescope.load_extension 'file_browser'
			end,
		},
	},

	-- Information
	{
		{
			'lewis6991/gitsigns.nvim',
			lazy = false,
			opts = {
				attach_to_untracked = false,
			},
		},
		{
			'nvim-lualine/lualine.nvim', -- TODO: configure
			dependencies = {
				'nvim-tree/nvim-web-devicons',
			},
			lazy = false,
			opts = {
				options = {
					theme = 'pywal',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = {
						{
							'filename',
							symbols = {
								readonly = '',
							},
						},
					},
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = {
						{
							'location',
							fmt = function(str) for l, c in string.gmatch(str, '(%d+):(%d+)') do return '' .. l .. ' ' .. c end end,
						},
					},
				},
			},
		},
		{
			'akinsho/bufferline.nvim', -- TODO: configure
			lazy = false,
			dependencies = {
				'nvim-tree/nvim-web-devicons',
				'pywal',
			},
			config = true,
		},
		{
			'j-hui/fidget.nvim',
			lazy = false,
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
			'nvim-treesitter/nvim-treesitter-textobjects',
			'windwp/nvim-ts-autotag',
		},
		lazy = false,
		opts = {
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = false },
			endwise = { enable = true },
			autotag = { enable = true },
			refactor = {
				smart_rename = {
					enable = true,
					keymaps = {
						smart_rename = '<leader>r',
					},
				},
			},
		},
	},

	-- Aesthetics
	{
		{
			'romainl/vim-cool',
			lazy = false,
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
			dependencies = {
				'AlphaTechnolog/pywal.nvim',
			},
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
			opts = {
				'javascript';
				'html';
				css = {
					css = true,
				};
			},
		},
	},
}

return plugins
