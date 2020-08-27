" Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Bundle 'https://github.com/chrisbra/Colorizer'
"Bundle 'itchyny/lightline.vim'
Bundle 'frazrepo/vim-rainbow'
Plugin 'fatih/vim-go'

Plugin 'preservim/nerdtree'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
autocmd vimenter * :AirlineTheme tenderplus

Plugin 'davidhalter/jedi-vim'
Bundle 'Raimondi/delimitMate'
"Bundle 'ycm-core/YouCompleteMe'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-sensible'
" Themes

Plugin 'jacoborus/tender.vim'
"Bundle 'tomasr/molokai'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"""""""""""""""""""
"filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab


" set spelllang = en_gb, nb_NO, nn_NO
set spell
set relativenumber

map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd vimenter * :ColorHighlight
"autocmd vimenter * NERDTree

autocmd BufWinEnter *.py nnoremap <F3> :w<CR>:!python3 %:p<CR>
autocmd BufWinEnter *.go nnoremap <F3> :w<CR>:GoRun<CR>

let g:delimitMate_expand_cr = 2
"
"Color scheme and correct parentesis highlights

"let g:lightline = {
""    \ 'colorscheme': 'wombat',
""    \ }

syntax on
colorscheme tender

hi MatchParen ctermfg=208 ctermbg=bg
