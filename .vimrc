" Preamble {{{
" ---------------------------------------------------------------------------

set nocompatible               " be iMproved

filetype on
filetype off
set runtimepath+=~/.vim/bundle/vundle/

call vundle#rc()

" }}}
" Plugins {{{
" ---------------------------------------------------------------------------

Bundle 'gmarik/vundle'

" Programming
Bundle 'matchit.zip'
Bundle 'taglist.vim'
" Bundle 'a.vim'
" Bundle 'cscope_macros.vim'
Bundle 'AutoTag'
Bundle 'tomtom/tcomment_vim'
Bundle 'scrooloose/syntastic'

" Snippets
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/snipmate-snippets'

" Git
Bundle 'tpope/vim-fugitive'

" Ruby
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-endwise'
Bundle 'ecomba/vim-ruby-refactoring'
" Bundle 'astashov/vim-ruby-debugger'
" http://blog.10to1.be/ruby/2011/02/13/vim-flog-plugin/
" Bundle 'fousa/vim-flog'
" :silent exe 'g:flog_enable'
" http://vimcasts.org/blog/2010/12/a-text-object-for-ruby-blocks/
" 'var' then 'ar' or 'ir'
Bundle 'kana/vim-textobj-user'
Bundle 'argtextobj.vim'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'mandre/vim-ruby-block-conv'

" Utility
Bundle 'YankRing.vim'
Bundle 'LargeFile'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-markdown'
Bundle 'file-line'
Bundle 'Align'
Bundle 'bufexplorer.zip'
Bundle 'netrw.vim'
Bundle 'ervandew/supertab'
Bundle 'ZoomWin'
Bundle 'mileszs/ack.vim'
Bundle 'sessionman.vim'
Bundle 'sjl/gundo.vim'
Bundle 'henrik/vim-indexed-search'
Bundle 'xolox/vim-notes'

" FuzzyFinder
" Bundle 'L9'
" Bundle 'FuzzyFinder'

" Command-T
" Bundle 'git://git.wincent.com/command-t'

" (HT|X)ml tool
" Bundle 'ragtag.vim'

" }}}
" General {{{
" ---------------------------------------------------------------------------

let mapleader = ","
let g:mapleader = ","
set encoding=utf-8
set history=50		" keep 50 lines of command line history
set hidden
set nobackup
set nowritebackup
set noswapfile
set undofile
set autoread
set sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize"
set nomodeline          " disable mode lines (security measure)

" Match and search
set ignorecase		" Do case insensitive matching
set smartcase
set gdefault
set incsearch		" do incremental searching
set showmatch		" Show matching brackets.
" Use sane regexes.
" nnoremap / /\v
" vnoremap / /\v

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Wildmenu completion {{{
set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store?                      " OSX bullshit
" }}}

" }}}
" UI {{{
" ---------------------------------------------------------------------------

set title
set scrolloff=3
set sidescroll=1
set sidescrolloff=10
set listchars+=precedes:❮,extends:❯
set showbreak=↪
set ruler
set showmode
set showcmd
set novisualbell
set backspace=indent,eol,start
" set laststatus=2
set virtualedit+=block

if has("gui_running")
  set cursorline
  " Highlight cursorline ONLY in the active window
  augroup cursor_line
    autocmd!
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup END
endif

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
"hi def link myTodo Todo
"match myTodo "\<TBD\>"
" syn match Todo "TBD" containedIn=ALL

if has("cscope")
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=1
endif

" }}}
" Text Formatting {{{
" ---------------------------------------------------------------------------

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Vimscript file settings {{{
  augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
  augroup END
  " }}}

  " text files settings {{{
  augroup filetype_text
    autocmd!
    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78
  augroup END
  " }}}

  " ruby files settings {{{
  augroup filetype_ruby
    autocmd!
    autocmd BufRead,BufNewFile {Gemfile,Rakefile,config.ru} set ft=ruby
    " For all Ruby and eRuby, set indent to 2 spaces
    autocmd FileType ruby setlocal ts=2 sw=2 expandtab
    autocmd FileType eruby setlocal ts=2 sw=2 expandtab

    " Delete trailing spaces from ruby files
    autocmd BufWritePre *.rb :%s/\s\+$//e
  augroup END
  " }}}

  " Utilities {{{
  augroup utilities
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

    "Change to current buffer directory
    "autocmd BufEnter * execute ":lcd " . expand("%:p:h")

    " Resize splits when the window is resized
    autocmd VimResized * exe "normal! \<c-w>="

    " When vimrc is edited, automatically reload it
    autocmd bufwritepost .vimrc source %
  augroup END
  " }}}
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

set formatoptions+=n1r

" }}}
" Status Line {{{
" ---------------------------------------------------------------------------

set statusline=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%{fugitive#statusline()}
set statusline+=\ %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" set statusline+=%{ruby_debugger#statusline()}

" }}}
" Mappings {{{
" ---------------------------------------------------------------------------

nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Surround with quotes
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $

" Use - to move current line down
noremap - ddp
" Use + to move current line up
noremap + ddkP

" <Ctrl>-d deletes the line
inoremap <c-d> <esc>ddi
" <Ctrl>-u make the current word uppercase
inoremap <c-u> <esc>viwUi

" Center screen when scrolling search results
" nnoremap n nzz
" nnoremap N Nzz

" Turn off arrow keys (this might not be a good idea for beginners, but it is
" the best way to ween yourself of arrow keys on to hjkl)
" http://yehudakatz.com/2010/07/29/everyone-who-tried-to-convince-me-to-use-vim-was-wrong/
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>"
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>

" Move between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Map ESC
inoremap jk <esc>
" inoremap <esc> <nop>

" Use :w!! to save file when current user doesn't have permission
cnoremap w!! %!sudo tee > /dev/null %

" Ctrl + space in insert mode activate autocompletion
" inoremap <c-space> <c-x><c-o>

" Shift + Enter adds an end
inoremap <S-CR> <CR><CR>end<Esc>-cc

nnoremap <space> :noh<CR>

" Don't use Ex mode, use Q for formatting
noremap Q gq

" Select pasted text
nnoremap <leader>v V`]

" Quick yanking to the end of the line
nmap Y y$

" Run Ack fast
nnoremap <leader>a :Ack<Space>

" Ruby refactoring
" Toggle between ruby block styles
nnoremap <leader>rb :B<CR>
" Toggle between post/pre conditional statements
nnoremap <leader>rc :RConvertPostConditional<CR>

" }}}
" Function Keys {{{
" ---------------------------------------------------------------------------

" <F1> Escape
inoremap <F1> <ESC>
noremap <F1> <ESC>
" <F2> File explorer
noremap <F2> :Ex<CR>
" <F3> Buffer explorer
noremap <F3> :BufExplorer<CR>
" <F4> Tag list
noremap <F4> :TlistToggle<CR>
" <F5> Reload file
noremap <F5> :e!<CR>
" <F6> Toggle wrap/nowrap
noremap <F6> :set wrap!<CR>
" <F7> Toggle GUndo tree
noremap <F7> :GundoToggle<CR>
" <F8> Comment
noremap <F8> :TComment<CR>j
" <F9> Remove all trailing spaces
noremap <F9> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" <F10> YankRing
nnoremap <silent> <F10> :YRShow<cr>
inoremap <silent> <F10> <ESC>:YRShow<cr>
" <F12> Compile using makefile
noremap <F12> :make<CR>

" }}}
" Plugins {{{
" ---------------------------------------------------------------------------

if has('mac')
  " Taglist
  let Tlist_Ctags_Cmd = '/opt/local/bin/ctags'
endif

" let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
" let g:ruby_debugger_progname = 'mvim'
" let g:CommandTMatchWindowAtTop=1 " show window at top

" SuperTab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCrMapping = 0

" Bufexplorer
let g:bufExplorerSortBy='fullpath'   " Sort by full file path name.

" Ruby refactoring
let g:ruby_refactoring_map_keys=0

" Show shorter messages for indexed search
let g:indexed_search_shortmess=1

" }}}
" GUI {{{
" ---------------------------------------------------------------------------

" Use a line-drawing char for pretty vertical splits.
set fillchars+=vert:│

if has("gui_running")
  " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
  " let &guioptions = substitute(&guioptions, "t", "", "g")
  set guioptions-=T " no toolbar
  set guioptions-=m " no menus
  set guioptions-=r " no scrollbar on the right
  set guioptions-=R " no scrollbar on the right
  set guioptions-=L " no scrollbar on the left
  set guioptions-=b " no scrollbar on the bottom
  set mousemodel=popup_setpos
  set noballooneval
  colorscheme two2tango

  if has('gui_macvim')
    set guifont=Menlo:h12
    set transparency=10
    set fuoptions=maxvert,maxhorz
  endif
endif

" }}}
" Misc {{{
" ---------------------------------------------------------------------------

set backupdir=~/tmp,/tmp
set undodir=~/.vim/.tmp,~/tmp,~/.tmp,/tmp
let g:yankring_history_dir="~/.vim/.tmp"
let g:notes_directory = '~/.vim/notes'

" latex specific stuff
let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'

set completeopt=menuone,preview
" Make Vim completion popup menu work just like in an IDE
" set completeopt=longest,menuone
" inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
" inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
" inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" }}}
