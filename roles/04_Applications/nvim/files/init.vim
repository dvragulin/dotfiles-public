"setup vim-plug {{{
  "Note: install vim-plug if not present
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
  endif
  if !1 | finish | endif
  if has('vim_starting')
    set nocompatible
    call plug#begin()
  endif
"}}}

" ---------- Plugins (Vim-plug) ------------------------------
" For plug instal need to use command ':source .vimrc' and ':PlugInstall' 
call plug#begin() 

" --- Pluggins for VIM ---------------------------------------
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }  " Folder Tree
Plug 'blueshirts/darcula',                               " Main color scheme
Plug 'jiangmiao/auto-pairs',                             " Auto pairs
"Plug 'tpope/vim-fugitive',                               " Helper for work with GIT 
"Plug 'airblade/vim-gitgutter'                            " Git left side lines
Plug 'kien/ctrlp.vim',                                   " Special find on Ctnl+P
Plug 'easymotion/vim-easymotion',                        " very fast move on text
Plug 'vim-airline/vim-airline',                          " Airline 
Plug 'vim-airline/vim-airline-themes',                   " Airline themes
Plug 'miyakogi/conoline.vim'                             " Cursor colors scheme
"Plug 'JamshedVesuna/vim-markdown-preview'                " Preview markdown files
Plug 'junegunn/fzf.vim'                                  " Fzf
Plug 'preservim/tagbar'                                  " Tagbar: a class outline viewer for Vim
Plug 'hashivim/vim-terraform'                            " Vim Terraform plugin
Plug 'Xuyuanp/nerdtree-git-plugin'                       " A plugin of NERDTree showing git status flags.
Plug 'ledesmablt/vim-run'                                " Run, view, and manage UNIX shell commands 
Plug 'towolf/vim-helm'
" for nvim
Plug 'kdheepak/lazygit.nvim' " LazyGit
Plug 'lewis6991/gitsigns.nvim' " Some for git
Plug 'folke/todo-comments.nvim'

" Fpr test

" TODO: Change airline for this :arrow-down:
"  Plug 'nvim-lualine/lualine.nvim'
"  " If you want to have icons in your statusline choose one of these
"  Plug 'kyazdani42/nvim-web-devicons'


call plug#end()
" ------------------------------------------------------------
" ---------- Settings ----------------------------------------
" ------------------------------------------------------------


set encoding=utf8
colorscheme darcula
let g:airline_theme='minimalist'
let g:gitgutter_terminal_reports_focus=0                 " for git-gutter
let g:conoline_auto_enable = 1                           " Enable conoline autostart
let g:airline#extensions#tagbar#enabled = 1              " Enable/disable tagbar integration
syntax enable
syntax on                                                " Settings for on/off syntax
set paste                                                " Fix paste to vim
set number                                               " Settings for left side numbers
set expandtab                                            " Settings tabs to spaces
set tabstop=4                                            " Settings number of spaces
set softtabstop=4
set shiftwidth=4
set hlsearch                                             " Settings for searching
set incsearch                                            " Settings for searchingh
set nowrap                                               " Chose `wrap` or `nowrap` the text after end of line
set mouse=a                                              " Enable mouse usage
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz " Add an ability to use hotkeys in a normal mode
set backspace=indent,eol,start
set noswapfile                                           " Cant create swp files
set fileformat=unix
set scrolloff=7
set colorcolumn=120


" ------------------------------------------------------------
" ---------- Mappings ----------------------------------------
" ------------------------------------------------------------

:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>
map <F8> :TagbarToggle<CR>
map <C-n> :NERDTreeToggle<CR>
nnoremap ,<space> :nohlsearch<CR>                        " turn off search highlight
let g:mapleader=','
map <silent> <C-h> :call WinMove('h')<CR>                " Call WinMove function
map <silent> <C-j> :call WinMove('j')<CR>                " Call WinMove function
map <silent> <C-k> :call WinMove('k')<CR>                " Call WinMove function
map <silent> <C-l> :call WinMove('l')<CR>                " Call WinMove function

" ------------------------------------------------------------
" ---------- Functions ---------------------------------------
" ------------------------------------------------------------

" -- Window Move ---------------------------------------------

function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

" ------------------------------------------------------------
" ---------- Plugins settings and mapping --------------------
" ------------------------------------------------------------

" --- NERDTree -----------------------------------------------
let NERDTreeShowHidden=1                                 " Show hidden files for NERDTree
let NERDTreeIgnore = ['\.idea', '\.pyc$', '.pyo$']       " Don't show these file types

" --- Vim Markdown Preview------------------------------------
let vim_markdown_preview_github=1                        " Enable markdown preview in GitHub stile
let vim_markdown_preview_use_xdg_open = 1                " Enable XDG providerfor open Firefox windows  
let vim_markdown_preview_hotkey='<C-m>'                  " Enabke hot key
let vim_markdown_preview_browser='Firefox'               " Set defautl browser for preview


" --- Vim Run ------------------------------------------------
let g:run_shell = $SHELL
let g:run_use_loclist = 0
let g:run_quiet_default = 0
let g:run_autosave_logs = 0
let g:run_nostream_default = 1
let g:run_browse_default_limit = 10

" --- TagBar settins -----------------------------------------
" https://github.com/preservim/tagbar/wiki#overview

let g:tagbar_type_ansible = {
    \ 'ctagstype' : 'ansible',
    \ 'kinds' : [
        \ 't:tasks'
    \ ],
    \ 'sort' : 0
\ }

let g:tagbar_type_yaml = {
    \ 'ctagstype' : 'yaml',
    \ 'kinds' : [
        \ 'a:anchors',
        \ 's:section',
        \ 'e:entry'
    \ ],
  \ 'sro' : '.',
    \ 'scope2kind': {
      \ 'section': 's',
      \ 'entry': 'e'
    \ },
    \ 'kind2scope': {
      \ 's': 'section',
      \ 'e': 'entry'
    \ },
    \ 'sort' : 0
    \ }

let g:tagbar_type_terraform = {
  \ 'ctagstype': 'terraform',
  \ 'kinds': [
    \ 'r:resource',
    \ 'R:Resource',
    \ 'd:data',
    \ 'D:Data',
    \ 'v:variable',
    \ 'V:Variable',
    \ 'p:provider',
    \ 'P:Provider',
    \ 'm:module',
    \ 'M:Module',
    \ 'o:output',
    \ 'O:Output',
    \ 'f:tfvar',
    \ 'F:TFVar'
  \ ]
\ }

let g:tagbar_type_sh = {  
    \ 'kinds':[
    \ 'f:functions',
    \ 'c:constants'
    \ ]
    \}

" ------------------------------------------------------------
