h1. My dotfiles (.files directory with content)

h2. Installation
The following steps are required after cloning 
h3. 1. Create the following logical links
You'd typically do this by doing by executing the following commands:
* .bashrc: ln -s .files/bashrc .bashrc
* .bash_profile: ln -s .files/bash_profile .bash_profile
* .vimrc: ln -s .files/vimrc .vimrc

h3. 2. Install vim Plug
My vim configurations contains many vim Plug plugins; execute the following command to use my .vimrc as intended:
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
