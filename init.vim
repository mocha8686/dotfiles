" Plugins
call plug#begin()

Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'gcmt/taboo.vim'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/nerdtree'
Plug 'preservim/tagbar'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'ryanoasis/vim-devicons'

call plug#end()

" Tagbar
nnoremap <C-y> :TagbarToggle<CR>
nnoremap <C-f> :TagbarOpenAutoClose<CR>

" Polyglot
let g:vim_svelte_plugin_use_sass = 1

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
nnoremap <C-t> :NERDTreeToggle<CR>

" CtrlP
nnoremap <C-p> :CtrlPMixed<CR>
let g:ctrlp_custom_ignore = {
	\ 'dir': '\(\.git\|node_modules\|dist\|target\)$'
\ }

" Taboo
nnoremap <C-i> :TabooRename 
nnoremap <C-u> :TabooReset<CR>
let g:taboo_tab_format = '%I %r%m %u'
let g:taboo_renamed_tab_format = '%I %l%m %u'
let g:taboo_modified_tab_flag = ' | +'

" Delete Hidden Buffers
nnoremap <C-q> :DeleteHiddenBuffers<CR>

" Functionality
set backspace=indent,eol,start
set history=25
set autoindent
set title
set encoding=utf-8
set incsearch ignorecase smartcase hlsearch
set nowrap
set whichwrap=b,s,<,>,[,]
set noexpandtab
set tabstop=4
set shiftwidth=4
set updatetime=100
nnoremap / /\v
nnoremap <C-s> :%s/\v
nnoremap <C-l> :tabnext<CR>
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-o> :tabnew<CR>
nnoremap <C-k> :tabclose<CR>


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
