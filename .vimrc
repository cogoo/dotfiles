" Add FZF to VIM
set rtp+=/usr/local/opt/fzf

" Add line numbers
set number

" Auto run nerd tree
autocmd vimenter * NERDTree

" Close Vim if NerdTree is the only one open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Key mappings for nerdtree
map  <C-l> :tabn<CR>

" Install VIM plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'

" Initialize plugin system
call plug#end()
