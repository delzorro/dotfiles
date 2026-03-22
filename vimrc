" Default configuration
source ~/.files/vimrc.default.configuration

" Plugins configuration
if !exists('g:skipPlugins') && filereadable(expand("~/.files/vimrc.plugin.configuration"))
	source ~/.files/vimrc.plugin.configuration
endif

" Allow pasting
function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  else
    return ''
  endif
endfunction
