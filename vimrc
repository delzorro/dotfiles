" No compabitlity necessary
set nocompatible

" Set alternative leader key
let mapleader = ";"

" Plugins + options
if filereadable(expand("~/.files/vimrc.plugins"))
	source ~/.files/vimrc.plugins
endif

" Custom functions
if filereadable(expand("~/.files/vimrc.functions"))
	source ~/.files/vimrc.functions
endif

" Custom mappings
if filereadable(expand("~/.files/vimrc.mappings"))
	source ~/.files/vimrc.mappings
endif

" Allow pasting
function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  else
    return ''
  endif
endfunction

" Operational settings
au BufNewFile,BufRead *.endfile set filetype=endfile
set encoding=utf-8
set sw=4
set tabstop=4
set nowrap
set scrolloff=5
set showmatch
set nobackup
set noswapfile
set number
"set relativenumber
set splitbelow
set splitright

" Search settings
set hlsearch
set smartindent
set ignorecase
set smartcase
set incsearch
hi Search ctermfg=green ctermbg=NONE cterm=underline         " Search results are coloured and underlined

" Character visibility
set listchars=tab:→\ ,space:·,nbsp:·,trail:•,eol:¶,precedes:«,extends:»

" Visual selection settings
highlight Visual cterm=reverse ctermbg=NONE

" Appearance 
syntax on
colorscheme gruvbox
set background=dark
set t_ut=
set t_Co=256
set term=screen-256color
"set cursorcolumn                                             " Highlight current cursor column
"hi CursorColumn cterm=NONE ctermbg=black                     " Set a vertical bar for the cursor
set cursorline                                                " Highlight current cursor line

" Status settings
set laststatus=2
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Completion settings
set wildmenu
set wildmode=full
