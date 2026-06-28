" claude-plan.nvimrc — neovim plan viewer met render-markdown.nvim

source ~/.files/vim/nvim.init.vim

colorscheme tokyonight-night

" Puur zwart achtergrond + iets witter body-tekst
hi Normal      guibg=#000000 guifg=#edf0f8
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

call timer_start(500, {-> execute('checktime')}, {'repeat': -1})
