" other vimrcs that this was inspired by:
" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim

" true color terminal
" taken from gruvbox: https://github.com/morhetz/gruvbox/wiki/Terminal-specific
" Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
" If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
" (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" install plug
" pulled from the readme for plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')
Plug 'dylanaraps/wal.vim'
Plug 'preservim/nerdtree'
Plug 'victor-iyi/commentary.vim'
Plug 'nvie/vim-flake8'
Plug 'nocksock/python-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', {'branch': '0.1.x'}
"Plug 'itchyny/lightline.vim'
Plug 'arakkkkk/kanban.nvim'
call plug#end()
let mapleader = "," 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
filetype on

" enable filetype plugins
filetype plugin on
filetype indent on


" set to autoread when a file is changed from the outside
" set autoread
" au FocusGained,BufEnter * silent! checktime

" linenumbers
set number
set rnu

set nowrap
set incsearch
set showcmd
set showmode
noremap oo  o<Esc>k
noremap OO O<ESC>j
"autocmd VimEnter * NERDTree | wincmd p


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set 7 lines to the cursor - when moving vertically using j/k
set so=7

" turn on wild menu and ignore compiled / incompatible files
set wildmenu
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Ignore case when searching
set ignorecase

" when searching try to be smart about cases
set smartcase

" highlight search results
set hlsearch

" make <Esc> clear search highlights
nnoremap <silent> <esc> <ESC>:nohlsearch<CR><Esc>

" make search act like search in modern browsers
set incsearch

" don't redraw while executing macros
set lazyredraw

" for regular expressions
set magic

" show matching brackets when text indicator is over them
set showmatch

" how many tenths of a second to blink when matching brackets
set mat=2

" no annoying sound on errors
set noerrorbells
set novisualbell
" set t_vb=
" set tm=500

"always show current position
set ruler

" add some margin to the left
set foldcolumn=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colors and fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" enable syntax highlighting
syntax on

" set regular expression engine automatically
" set regexpengine=0

set background=dark

" options:
" gruvbox, blue_in_green
" options listed here: https://github.com/rafi/awesome-vim-colorschemes
colorscheme 

set encoding=utf8


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files, backups, and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" turn off backup
" set nobackup
" set nowb
" set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" text, tabs, indents
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set smarttab

" spacing
set shiftwidth=4
set tabstop=4

" set ai " auto indent
" set si " smart indent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
" Visual mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
" vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
" vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moving around tabs, windows, and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" better way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" tabs
" https://webdevetc.com/blog/tabs-in-vim/
map <leader>tn :tabnew<cr>
map <leader>t<leader> :tabnext
map <leader>tm :tabmove
map <leader>tc :tabclose<c>
map <leader>to :tabonly<cr>


" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" always show the status line
set laststatus=2

" Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
" set statusline=\test \ \ Line:\ %l \ Column:\ %c
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_spell=1
let g:airline_theme='dark'
let g:airline_powerline_fonts=1
" set statusline=helloworld
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" remap VIM 0 to the first non-blank character
map 0 ^


" fast quit / save
nmap <leader>w :w!<cr>
"nmap <leader>q :q!<cr>

" clear highlight on pressing ESC
" nnoremap <esc> :noh<return><esc>


" Delete trailing white space on save, useful for some filetypes ;)
" fun! CleanExtraSpaces()
"     let save_cursor = getpos(".")
"     let old_query = getreg('/')
"     silent! %s/\s\+$//e
"     call setpos('.', save_cursor)
"     call setreg('/', old_query)
" endfun

" if has("autocmd")
"     autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
" endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" exit vim in NERDTree is the only window remaining
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" let g:NERDTreeWinPos = "left"
" let NERDTreeShowHidden = 0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
" let g:NERDTreeWinSize=35

"""""""""""""""""""""""""""""""""""
let g:python_highlight_all = 1
let g:mkdp_command_for_global = 1
let g:mkdp_auto_start = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" persistent undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" try
"     set undodir=~/.vim_runtime/temp_dirs/undodir
"     set undofile
" catch
" endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" python 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let python_highlight_all = 1
" au FileType python syn keyword pythonDecorator True None False self
" 
" au BufNewFile,BufRead *.jinja set syntax=htmljinja
" au BufNewFile,BufRead *.mako set ft=mako
" 
au FileType python map <buffer> F :set foldmethod=indent<cr>
" 
" au FileType python inoremap <buffer> $r return 
" au FileType python inoremap <buffer> $i import 
" au FileType python inoremap <buffer> $p print 
" au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 

""""""""""""""""""""""""""""""
" Markdown
""""""""""""""""""""""""""""""
" let vim_markdown_folding_disabled = 1


""""""""""""""""""""""""""""""
" YAML
""""""""""""""""""""""""""""""
" autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" 
" " ensure vim starts in normal mode
" autocmd VimEnter * silent! normal! <Esc>

""""""""""""""""""""""""""""""
" Telescope
" """"""""""""""""""""""""""""
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr> 
