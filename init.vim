" Plugins
call plug#begin()

Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'adelarsq/vim-matchit'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'preservim/tagbar'
Plug 'ludovicchabant/vim-gutentags'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'ryanoasis/vim-devicons'

call plug#end()

" Lightline
let g:lightline = {
	\ 'active': {
	\ 	'left': [
	\ 		[ 'mode', 'paste' ],
	\ 		[ 'readonly', 'filename', 'modified' ]
	\ 	],
	\ 	'right': [
	\ 		[ 'lineinfo' ],
	\ 		[ 'percent' ],
	\ 		[ 'fileformat', 'fileencoding', 'filetype' ]
	\ 	]
	\ },
\ }

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Tagbar
nnoremap <C-y> :TagbarToggle<CR>

" CtrlP
nnoremap <C-p> :CtrlPMixed<CR>
let g:ctrlp_custom_ignore = {
	\ 'dir': '\(\.git\|node_modules\|dist\)$'
\ }

" Functionality
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
nnoremap / /\v

" Information
set noshowmode
set showcmd
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
