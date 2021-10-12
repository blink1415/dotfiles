set nocompatible              " be iMproved, required
filetype off                  " required

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Bundle 'https://github.com/chrisbra/Colorizer'
Bundle 'frazrepo/vim-rainbow'

"Plugin 'fatih/vim-go'
Plugin 'vim-syntastic/syntastic'
Plugin 'preservim/nerdtree'
Plugin 'rust-lang/rust.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"autocmd vimenter * :AirlineTheme tenderplus

"Plugin 'davidhalter/jedi-vim'
Bundle 'Raimondi/delimitMate'
"Bundle 'ycm-core/YouCompleteMe'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-sensible'
" Themes

"Plugin 'jacoborus/tender.vim'
Bundle 'srcery-colors/srcery-vim'
"Bundle 'tomasr/molokai'

call vundle#end()            " required
filetype plugin indent on    " required


set tabstop=4
set shiftwidth=4
set expandtab

set spell

"set relativenumber
set number

" Nerdtree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd vimenter * :ColorHighlight

"autocmd vimenter * NERDTree

let g:delimitMate_expand_cr = 2

" Color scheme
syntax on
colorscheme srcery

" Parenthesis fix
hi MatchParen ctermfg=208 ctermbg=bg


" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Rust
let g:rustfmt_autosave = 1
