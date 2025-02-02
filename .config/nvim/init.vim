set nocompatible

call plug#begin()

Plug 'tomtom/tcomment_vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'
Plug 'sheerun/vim-polyglot'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-syntastic/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'w0rp/ale'
Plug 'plasticboy/vim-markdown'
Plug 'Quramy/tsuquyomi'
Plug 'drewtempelmeyer/palenight.vim'

call plug#end()

" auto install plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" make backspaces delete sensibly
set backspace=indent,eol,start

set smartcase
set ignorecase

" tab completion for files recursively
set path+=**

" display matching files on tab complete
set wildmenu

" tree view
let g:netrw_banner = 0
let g:netrw_keepdir = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 30
let g:netrw_sort_sequence = '[\/]$,*'

augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Lexplore
augroup END

set laststatus=2
set noshowmode

" theme
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

set background=dark
colorscheme palenight

" lightline
let g:lightline = { 'colorscheme': 'palenight', }

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']

" ale
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
