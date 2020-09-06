# My dotfiles (.files directory with content)
This project contains the dotfiles I use for Linux, vim and tmux.
If you want to see it functional, please read and execute the installation section below. 

## Installation
The following steps are required to get the dotfiles functional, and assume that the cloned ".files"-directory is located in your home directory.

### 1. Create the following logical links
* .bashrc: ln -s .files/bashrc .bashrc
* .bash_profile: ln -s .files/bash_profile .bash_profile
* .zshrc: ln -s .files/zshrc .zshrc
* .vimrc: ln -s .files/vimrc .vimrc
* .tmux.conf: ln -s .files/tmux.conf .tmux.conf

### 2. Install vim Plug
My vim configuration contains vim Plug plugins, so you need to install vim Plug in order to use my .vimrc as intended. 
Installing vim Plug can be accomplished by running the following command:
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

After above installation has completed, reload your .vimrc and type :PlugInstall (in normal mode) to install the plugins.
