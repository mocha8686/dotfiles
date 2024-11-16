local project_config_module_name = 'nvimconfig'

local function no_numbers()
	return vim.b['term_title']
		or vim.bo.filetype == 'man'
		or vim.bo.filetype == 'help'
		or string.find(vim.bo.filetype, 'dap')
end

-- Vim options
local function set_vim_options()
	local opt = vim.opt
	local g = vim.g
	local autocmd = vim.api.nvim_create_autocmd

	-- Navigation
	opt.backspace = 'indent,eol,start'
	opt.hlsearch = true
	opt.ignorecase = true
	opt.incsearch = true
	opt.smartcase = true
	opt.splitbelow = true
	opt.splitright = true
	opt.whichwrap = 'b,s,<,>,[,]'

	-- Editing
	opt.autoindent = true
	opt.expandtab = false
	opt.shiftwidth = 4
	opt.tabstop = 4
	opt.undofile = true

	-- Styling
	opt.encoding = 'utf-8'
	opt.laststatus = 3
	opt.list = true
	opt.number = true
	opt.relativenumber = true
	opt.scrolloff = 7
	opt.showbreak = '↪ '
	opt.showcmd = true
	opt.showmode = false
	opt.sidescroll = 10
	opt.signcolumn = 'yes'
	opt.termguicolors = true
	opt.title = true
	opt.updatetime = 150
	opt.wrap = false
	opt.listchars = {
		trail = '⋅',
		extends = '⟩',
		precedes = '⟨',
		tab = '»⋅',
		nbsp = '␣',
	}
	opt.fillchars = {
		stl = ' ',
		stlnc = ' ',
		wbr = ' ',
	}

	-- Misc
	opt.history = 25

	g.mapleader = ' '
	g.maplocalleader = '\\'

	local number_augroup = vim.api.nvim_create_augroup('SetNumberRelativeNumber', { clear = true })
	autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
		group = number_augroup,
		pattern = '*',
		callback = function()
			if not no_numbers() then
				opt.relativenumber = true
			end
		end,
	})
	autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
		group = number_augroup,
		pattern = '*',
		callback = function()
			if not no_numbers() then
				opt.relativenumber = false
			end
		end,
	})

	autocmd('FileType', {
		pattern = { 'text', 'markdown', 'tex', 'plaintex' },
		callback = function()
			opt.wrap = true
			opt.linebreak = true
		end,
	})

	autocmd('TermOpen', {
		pattern = '*',
		callback = function()
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
		end,
	})
end

local function override_colortheme()
	local cmd = vim.cmd

	cmd [[ highlight StatusLine guibg=red ]]
	cmd [[ highlight StatusLineNC guibg=green ]]

	cmd [[ highlight WinSeparator guibg=bg guifg=#333333 ]]

	cmd [[ highlight NonText guifg=444444 ]]
	cmd [[ highlight Whitespace guifg=#444444 ]]
end

local function load_project_config()
	if vim.fn.filereadable(project_config_module_name .. '.lua') ~= 0 then
		require(project_config_module_name)
	end
end

-- Lazy
local function ensure_lazy()
	local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system {
			'git',
			'clone',
			'--filter=blob:none',
			'https://github.com/folke/lazy.nvim.git',
			'--branch=stable', -- latest stable release
			lazypath,
		}
	end
	vim.opt.rtp:prepend(lazypath)
end

set_vim_options()
require('keys').map_plugin_keys 'vim'
ensure_lazy()

local plugins = require 'plugins'
require('lazy').setup(plugins, {
	defaults = {
		lazy = true,
	},
})

override_colortheme()
load_project_config()
