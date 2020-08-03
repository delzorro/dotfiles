# My dotfiles (.files directory with content)
This project contains the dotfiles I use for Linux, vim and tmux.
If you want to see it functional, please read and execute the installation section below. 

## Installation
The following steps are required to get the dotfiles functional, and assume that the cloned ".files"-directory is located in your home directory.

### 1. Create the following logical links
* .bashrc: ln -s .files/bashrc .bashrc
* .bash_profile: ln -s .files/bash_profile .bash_profile
* .vimrc: ln -s .files/vimrc .vimrc

### 2. Install vim Plug
My vim configurations contains vim Plug plugins, so you need to install vim Plug in order to use my .vimrc as intended. 
Installing vim Plug can be accomplished by running the following command:
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
