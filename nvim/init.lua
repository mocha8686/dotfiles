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
	opt.showcmd = true
	opt.showmode = false
	opt.sidescroll = 10
	opt.signcolumn = 'yes'
	opt.termguicolors = true
	opt.title = true
	opt.updatetime = 150
	opt.wrap = false
	opt.listchars = {
		trail = '*',
		extends = '>',
		precedes = '<',
		tab = '>.',
	}
	opt.fillchars = {
		stl = ' ',
		stlnc = ' ',
		wbr = ' ',
	}

	-- Misc
	opt.history = 25

	g.mapleader = ' '

	autocmd({'BufEnter', 'FocusGained', 'InsertLeave'}, {
		pattern = '*',
		callback = function()
			opt.relativenumber = true
		end
	})
	autocmd({'BufLeave', 'FocusLost', 'InsertEnter'}, {
		pattern = '*',
		callback = function()
			opt.relativenumber = false
		end
	})

	autocmd('FileType', {
		pattern = {'text', 'markdown', 'tex', 'plaintex'},
		callback = function()
			opt.wrap = true
		end
	})
end

local function set_vim_maps()
	local map = vim.keymap.set
	local opts = { silent = true, remap = true }

	map({'n'}, '<C-h>', '<C-w>h', opts)
	map({'n'}, '<C-j>', '<C-w>j', opts)
	map({'n'}, '<C-k>', '<C-w>k', opts)
	map({'n'}, '<C-l>', '<C-w>l', opts)

	map({'n'}, '<Tab>', '<Cmd>bn<CR>', opts)
	map({'n'}, '<S-Tab>', '<Cmd>bp<CR>', opts)
end

local function override_colortheme()
	local cmd = vim.cmd

	cmd [[ highlight StatusLine guibg=red ]]
	cmd [[ highlight StatusLineNC guibg=green ]]

	cmd [[ highlight WinSeparator guibg=bg guifg=#333333 ]]

	cmd [[ highlight NonText guifg=444444 ]]
	cmd [[ highlight Whitespace guifg=#444444 ]]
end

-- Lazy
local function ensure_lazy()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
end

set_vim_options()
set_vim_maps()
ensure_lazy()

local plugins = require 'plugins'
require('lazy').setup(plugins, {lazy = true})

override_colortheme()
