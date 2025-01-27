" vim: set foldmethod=marker foldlevel=0 nomodeline:
" nvim/init.vim

set runtimepath^=$HOME/.vim
call plug#begin('~/.vim/plugged')
" On-demand loading: loaded when the specified command is executed
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
" Unmanaged plugin (manually installed and updated)
Plug '~/projects/llm.vim'
Plug 'luochen1990/rainbow'

call plug#end()

" Set line number display
set number
set encoding=utf-8
set fileformat=unix

" Customize the statusline
set statusline=%<%F\ %y\ [%{&fileencoding?&fileencoding:&encoding}]\ \ \ %m%r%h\ %w\ \ \ \ %-14.(%l,%c%V%)\ %P

let g:rainbow_active = 1
let mapleader = "\<space>"
" Map Y to copy to system clipboard in visual and visual select mode
vnoremap Y "+y
xnoremap Y "+y
vnoremap <leader>y "+y
xnoremap <leader>y "+y

set list
set listchars=eol:⏎,tab:»-,trail:-,nbsp:.

let g:python3_host_prog = 'C:\Python311\python.exe'
" llm.vim
let g:llm_config_path = expand('$HOME/.config/llm/llm.vim.yaml')
let g:llm_system_prompt = ''
let g:llm_model_name = 'deepkseek-chat' " 'doubao-1.5-pro'

nnoremap <leader>t :NERDTreeToggle<CR>

" copy from my minimal config used in Unix

" use ":verbose set <option>?" to debug the source of option changes
" ========== vim basic options ========= {{{

" highlight text line of cursor
set cursorline
" highlight text column of cursor
set nocursorcolumn

" workaround for italics
" https://rsapkf.xyz/blog/enabling-italics-vim-tmux
set t_ZH=[3m
set t_ZR=[23m

" Encoding
scriptencoding utf-8
set fileencodings=utf-8,cp936
set fileencoding=utf-8
set encoding=utf8

" backspace
" see :help bs
" Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode.
set bs=indent,eol,start


" whether to use Python 2 or 3
set pyx=3

" true color
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if has("termguicolors")
    set termguicolors
  endif
endif

" double with chracter
" set ambiwidth=double
" display endofline tab space enter
set nocompatible " be iMproved, required
set list
set listchars=eol:⏎,tab:»-,trail:-,nbsp:.
" show break
set showbreak=⌞
" linebreak
set linebreak
" decrease memory usage
set bufhidden=wipe

"show command line
set showcmd
" Give more space for displaying messages.
set cmdheight=2

" opening message hit-enter
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=100
" By default timeoutlen is 1000 ms
set timeout
" map sequence timeout
set timeoutlen=500
" key code timeout
set ttimeoutlen=256

" maximum amount of memory to use for pattern matching (in Kbyte)
" avoid E363
set maxmempattern=20000
" regex magic
set magic
" modeline
set modeline


" Backup and swap
" Some servers have issues with backup files, see coc.vim/#649.
" not createing swap file for new buffers
set nowritebackup
set nobackup
set nowritebackup
set noundofile
if has('nvim')
  set shada="NONE"
 else
  set viminfo="NONE"
endif

" disable swap file
set noswapfile

" Don't pass messages to |ins-completion-menu|.
" set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=yes
else
  set signcolumn=yes:3
endif

" grepprg
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m


" tags
set tags=./tags;,.tags,tags;,./.tags;

" Undo settings
if has('persistent_undo')
  set undofile
  set undolevels=10240
  if has('nvim')
    set undodir=~/.config/nvim/tmp/undo,.
  endif
endif

set laststatus=2
if !has('gui_running')
  set t_Co=256
  " https://github.com/dracula/vim/issues/96
  let g:dracula_colorterm = 0
else
  if has('nvim')
    autocmd UIEnter * let g:gui = filter(nvim_list_uis(),{k,v-> v.chan==v:event.chan})[0].rgb
  endif
endif
set noshowmode


" syntax highlighting
syntax enable
syntax on

" close sounds on erros
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" ctrl-a/ctrl-x as decimal number
set nrformats=

" show linenumber
set number
set numberwidth=4

" show line number relative to current line where cursor is
set norelativenumber

" check filetype
filetype on

" Indent {{{

" always use tab character
" set noexpandtab

" always use space by default
set expandtab

set shiftwidth=2

" Number of spaces that a <Tab> in the file counts for.
" shift indent
" set tabstop=8
set tabstop=2
set textwidth=120

" Number of spaces that a <Tab> counts for while performing editing
" operations, like inserting a <Tab> or using <BS>.
set softtabstop=2

" Do smart autoindenting when starting a new line.
set nosmartindent

" When on, a <Tab> in front of a line inserts blanks according to'shiftwidth'.
set nosmarttab
set noautoindent

" use spaces wtih < or > commands
" set autoindent
" }}}

" show match
set showmatch

" show command line
set showcmd
set cmdheight=2

" Better command-line completion
set wildmenu

" show cursor location
set ruler

" highlight searchs
set hlsearch
set incsearch


" menu language
set langmenu=en_US.UTF-8

" ignore cases by default
set ic

" change directory automatically
set autochdir

" message
" language messages en_US.utf-8

" auto-reload working directory
" autocmd BufEnter * lcd %:p:h

" mouse support
" normal, visual mode
set mouse=nv

" tabline-settings {{{
" 0: never, 1: show when 2 or more tabs, 3: always
set showtabline=2

" }}}
" }}}
