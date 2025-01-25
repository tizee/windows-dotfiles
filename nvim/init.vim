" Set line number display
set number

" Map Y to copy to system clipboard in visual and visual select mode
vnoremap Y "+y
xnoremap Y "+y

" Customize the statusline
set statusline=%<%F\ %y\ [%{&fileencoding?&fileencoding:&encoding}]\ \ \ %m%r%h\ %w\ \ \ \ %-14.(%l,%c%V%)\ %P
