" Ensure compatibility with older versions of Vim
set nocompatible

" Make fd or df behave like the Escape key in insert mode
inoremap fd <Esc>
inoremap df <Esc>

" Enable line numbers
set number

" Enable relative line numbers
set relativenumber

" Auto indenting
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Highlight the search results
set hlsearch

" Incremental live search
set incsearch

" Show matching parenthesis when one is under cursor
set showmatch

" Set the command-line height to 2
set cmdheight=2

" Automatically open and close the popup menu when entering/completing
set wildmenu
set wildmode=list:longest

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Enable line and column number in the status bar
set ruler

" Enable persistent undo so undo history is saved across sessions
if has('persistent_undo')
  set undodir=~/.vim/undodir
  set undofile
endif

" Enable syntax highlighting
syntax on

" Enable filetype plugins and indenting
filetype plugin indent on

" Set mouse=a enables mouse in all modes
set mouse=a

" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Easier buffer switch
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>

" Auto close brackets, quotes, etc.
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" If you prefer dark themes, you can uncomment the line below
" set background=dark
