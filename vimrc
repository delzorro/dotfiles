" Mandatory vimrc file
source ~/.files/vimrc.settings

" Custom mappings
if filereadable(expand("~/.files/vimrc.mappings"))
	source ~/.files/vimrc.mappings
endif

" Plugins + options
if !exists('g:skipPlugins') && filereadable(expand("~/.files/vimrc.plugins"))
	source ~/.files/vimrc.plugins
endif

" Custom functions; obsolete?
if filereadable(expand("~/.files/vimrc.functions"))
	source ~/.files/vimrc.functions
endif


" Allow pasting
function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  else
    return ''
  endif
endfunction
