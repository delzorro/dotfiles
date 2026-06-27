source ~/.files/vim/vimrc.default.configuration

if filereadable(expand("~/.files/vim/nvimrc.plugin.configuration"))
	source ~/.files/vim/nvimrc.plugin.configuration
endif
