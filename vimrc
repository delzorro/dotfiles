" Default configuration
source ~/.files/vimrc.default.configuration

" Markdown configuration
source ~/.files/vimrc.markdown.configuration

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
