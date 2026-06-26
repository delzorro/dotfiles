" claude-plan.vimrc — laadt de volledige vimrc en voegt plan-viewer instellingen toe

source ~/.vimrc

" Plan-viewer specifiek
set autoread
set noswapfile
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" Transparante achtergrond (na colorscheme zodat het niet overschreven wordt)
highlight Normal      ctermbg=NONE guibg=NONE
highlight NonText     ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

" Auto-refresh: elke 500ms checktime ongeacht focus
call timer_start(500, {-> execute('checktime')}, {'repeat': -1})
