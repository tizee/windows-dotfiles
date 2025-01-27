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
set listchars=tab:<->,space:·,eol:󱞲,trail:·,lead:.

let g:python3_host_prog = 'C:\Python311\python.exe'
" llm.vim
let g:llm_config_path = expand('$HOME/.config/llm/llm.vim.yaml')
let g:llm_system_prompt = ''
let g:llm_model_name = 'deepkseek-chat' " 'doubao-1.5-pro'

nnoremap <leader>t :NERDTreeToggle<CR>
