" claude-plan.nvimrc — neovim plan viewer met render-markdown.nvim

source ~/.files/vim/nvim.init.vim

colorscheme tokyonight-night

" Puur zwart achtergrond + iets witter body-tekst
hi Normal      guibg=#000000 guifg=#dde2f0
hi NormalNC    guibg=#000000
hi NonText     guibg=#000000
hi EndOfBuffer guibg=#000000
hi LineNr      guibg=#000000
hi SignColumn  guibg=#000000

set autoread
set noswapfile
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" conceallevel=1: syntax-markers tonen als één teken i.p.v. volledig verbergen
" 0 = alles zichtbaar, 1 = één marker, 2 = volledig verborgen (render-markdown default)
autocmd FileType markdown setlocal conceallevel=1

call timer_start(500, {-> execute('checktime')}, {'repeat': -1})
