-- Vim options
local function set_vim_options()
	vim.opt.backspace = 'indent,eol,start'
	vim.opt.history = 25
	vim.opt.autoindent = true
	vim.opt.title = true
	vim.opt.encoding = 'utf-8'
	vim.opt.incsearch = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.hlsearch = true
	vim.opt.wrap = false
	vim.opt.whichwrap = 'b,s,<,>,[,]'
	vim.opt.expandtab = false
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.updatetime = 150
	vim.opt.showmode = false
	vim.opt.showcmd = true
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.scrolloff = 7
	vim.opt.sidescroll = 10
	vim.opt.list = true
	vim.opt.listchars = {
		trail = '*',
		extends = '>',
		precedes = '<',
		tab = '>.',
	}
	vim.opt.fillchars = {
		stl = ' ',
		stlnc = ' ',
		wbr = ' ',
	}

	local map = vim.keymap.set
	local opts = { silent = true, noremap = true }
	map('t', '<ESC>', '<C-\\><C-n>', opts)

	vim.cmd [[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
	]]
	vim.cmd [[
	augroup numbertoggle
		autocmd!
		autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
		autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
	augroup END
	]]
end

set_vim_options()

-- Packer
local function ensure_packer()
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'lewis6991/impatient.nvim'

	-- Editing
	use {
		'andymass/vim-matchup',
		{
			'junegunn/vim-easy-align',
			config = function()
				local map = vim.keymap.set
				local opts = { silent = true, noremap = true }
				map({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)', opts)
			end
		},
		{
			'windwp/nvim-autopairs',
			config = function()
				require('nvim-autopairs').setup()
			end,
		},
		{
			'numToStr/Comment.nvim',
			config = function()
				require('Comment').setup()
			end,
		},
		{
			'kylechui/nvim-surround',
			requires = {
				'nvim-treesitter/nvim-treesitter',
				'nvim-treesitter/nvim-treesitter-textobjects',
			},
			config = function()
				require('nvim-surround').setup()
			end
		},
	}

	-- Git
	use {
		'akinsho/git-conflict.nvim',
		tag = '*',
		config = function()
			require('git-conflict').setup()
		end,
	}

	-- LSP
	use {
		{
			'hrsh7th/nvim-cmp',
			requires = {
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
			requires = {
				'folke/todo-comments.nvim',
				'folke/trouble.nvim',
				'hrsh7th/nvim-cmp',
				'nvim-telescope/telescope.nvim',
				'ray-x/lsp_signature.nvim',
				'rcarriga/nvim-notify',
				'williamboman/mason.nvim',
			},
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
					local opts = { silent = true, noremap = true, buffer = buf }

					map('n', 'gD', vim.lsp.buf.declaration, opts)
					map('n', 'gd', telescope_builtin.lsp_definitions, opts)
					map('n', 'K', vim.lsp.buf.hover, opts)
					map('n', 'gi', telescope_builtin.lsp_implementations, opts)
					map('n', 'gS', vim.lsp.buf.signature_help, opts)
					map('n', 'gr', telescope_builtin.lsp_references, opts)
					map({ 'n', 'v' }, 'gA', vim.lsp.buf.code_action, opts)
					map('n', ']e', function() vim.diagnostic.goto_next { float = {scope = "line"} } end, opts)
					map('n', '[e', function() vim.diagnostic.goto_prev { float = {scope = "line"} } end, opts)

					map('n', '<leader>xx', '<CMD>TroubleToggle<CR>', opts)
					map('n', '<leader>xw', '<CMD>TroubleToggle workspace_diagnostics<CR>', opts)
					map('n', '<leader>xd', '<CMD>TroubleToggle document_diagnostics<CR>', opts)
					map('n', '<leader>xl', '<CMD>TroubleToggle loclist<CR>', opts)
					map('n', '<leader>xq', '<CMD>TroubleToggle quickfix<CR>', opts)
					map('n', '<leader>xt', '<CMD>TodoTrouble<CR>', opts)
					map('n', 'gR', '<CMD>TroubleToggle lsp_references<CR>', opts)
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
			requires = 'neovim/nvim-lspconfig',
			config = function()
				require('nvim-lightbulb').setup {
					autocmd = {
						enabled = true,
					},
				}
			end,
		},
	}

	-- Navigation
	use {
		'chaoren/vim-wordmotion',
		'wellle/targets.vim', -- TODO: read
		{
			'mhinz/vim-sayonara',
			config = function()
				local map = vim.keymap.set
				local opts = { silent = true, noremap = true }
				map('n', '<leader>d', '<CMD>Sayonara!<CR>', opts)
				map('n', '<leader>c', '<CMD>Sayonara<CR>', opts)
			end
		},
		{
			'ggandor/leap.nvim',
			requires = 'tpope/vim-repeat',
			config = function()
				local map = vim.keymap.set
				local opts = { noremap = true }
				map({ 'n', 'x', 'o' }, 'z', '<Plug>(leap-forward-x)', opts)
				map({ 'n', 'x', 'o' }, 'Z', '<Plug>(leap-backward-x)', opts)
			end,
		},
		{
			'ggandor/flit.nvim', -- TODO: read
			requires = 'ggandor/leap.nvim',
			config = function()
				require('flit').setup {
					labeled_modes = 'nv',
				}
			end,
		},
	}

	-- Telescope
	use {
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
		},
		{
			'nvim-telescope/telescope-frecency.nvim',
			requires = 'kkharji/sqlite.lua',
		},
		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.x',
			requires = {
				'nvim-lua/plenary.nvim',
				'nvim-telescope/telescope-file-browser.nvim',
				'nvim-telescope/telescope-fzf-native.nvim',
				'nvim-telescope/telescope-ui-select.nvim',
			},
			config = function()
				local telescope = require 'telescope'
				local telescope_builtin = require 'telescope.builtin'

				local theme = 'dropdown'

				local map = vim.keymap.set
				local opts = { silent = true, noremap = true }
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
	}

	-- Information
	use {
		{
			'lewis6991/gitsigns.nvim',
			config = function()
				require('gitsigns').setup {
					attach_to_untracked = false,
				}
			end,
		},
		{
			'nvim-lualine/lualine.nvim', -- TODO: configure
			requires = {
				'nvim-tree/nvim-web-devicons',
			},
			config = function()
				require('lualine').setup {
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
				}
			end,
		},
		{
			'akinsho/bufferline.nvim', -- TODO: configure
			tag = 'v3.*',
			requires = 'nvim-tree/nvim-web-devicons',
			after = 'pywal',
			config = function()
				require('bufferline').setup()
			end,
		},
		{
			'j-hui/fidget.nvim',
			config = function()
				require('fidget').setup()
			end,
		},
	}

	-- Treesitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		requires = {
			'RRethy/nvim-treesitter-endwise',
			'nvim-treesitter/nvim-treesitter-refactor',
			'nvim-treesitter/nvim-treesitter-textobjects',
			'windwp/nvim-ts-autotag',
		},
		config = function()
			require('nvim-treesitter.configs').setup {
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
			}
		end,
	}

	-- Aesthetics
	use {
		'romainl/vim-cool',
		{
			'AlphaTechnolog/pywal.nvim',
			as = 'pywal',
			config = function()
				require('pywal').setup()
			end,
		},
		{
			'norcalli/nvim-colorizer.lua',
			after = 'pywal',
			config = function()
				require('colorizer').setup {
					'javascript';
					'html';
					css = {
						css = true,
					};
				}
			end,
		},
	}

	if packer_bootstrap then
		require('packer').sync()
	end
end)
