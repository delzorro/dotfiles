" claude-plan.nvimrc — neovim plan viewer met render-markdown.nvim

source ~/.files/vim/nvim.init.vim

set autoread
set noswapfile
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set conceallevel=0

call timer_start(500, {-> execute('checktime')}, {'repeat': -1})
