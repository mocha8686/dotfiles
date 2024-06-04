" Plugins
call plug#begin()

Plug 'junegunn/fzf.vim'
Plug 'chemzqm/vim-jsx-improve'
Plug 'jiangmiao/auto-pairs'
Plug 'adelarsq/vim-matchit'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'

call plug#end()

" Lightline
let g:lightline = {
	\ 'active': {
	\ 	'left': [
	\ 		[ 'mode', 'paste' ],
	\ 		[ 'readonly', 'filename', 'modified', 'helloworld' ]
	\ 	],
	\ 	'right': [
	\ 		[ 'lineinfo' ],
	\ 		[ 'percent' ],
	\ 		[ 'fileformat', 'fileencoding', 'filetype' ]
	\ 	]
	\ },
	\ }

" Functionalities
set backspace=indent,eol,start
set history=25
set autoindent
set title
set encoding=utf-8
set incsearch ignorecase smartcase hlsearch
set nowrap
set whichwrap=b,s,<,>,[,]
set tabstop=4
set shiftwidth=4
set updatetime=100

" Information
set noshowmode
set showcmd
set ruler
set number relativenumber
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END
set scrolloff=7
set sidescroll=10
set list
set listchars=trail:*,extends:>,precedes:<,tab:>.
