# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Stop when not running interactively
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# set a fancy prompt (non-color, unless we know we "want" color)
TERM='xterm-256color'
PROMPT_COMMAND=setBashPromp
# Function to set prompt including last command's exist status
function setBashPromp {
    local EXIT="$?"             # This needs to be first

	# set variable identifying the chroot you work in (used in the prompt below)
	# -> (how) is this used ??
	debian_chroot=""
	if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
			debian_chroot=$(cat /etc/debian_chroot)
	fi
    local resetCol='\[\e[0m\]'
    local redCol='\[\e[0;31m\]'
    local greenCol='\[\e[0;32m\]'
    local lightGreenCol='\[\e[0;92m\]'
    local boldBlueCol='\[\e[1;34m\]'
    local lightBlueCol='\[\e[0;94m\]'
	local boldYellowCol='\[\e[1;33m\]'
    local purpleColor='\[\e[0;35m\]'
	# Former PS1 configuration
	#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\a\[\033[00m\]\$ '

	# Current PS1 configuration
	PS1="${lightGreenCol}\u@\h:${boldBlueCol}\w\a${resetCol}\$ "
	# Display whether last command's exit code was an error code
    if [ $EXIT != 0 ]; then
        PS1="[${redCol}✗${resetCol}]${PS1}"      
    else
        PS1="[${lightGreenCol}✔${resetCol}]${PS1}"
    fi
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Default fzf bash-izzle
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Load shell indepenent settings
[ -f ~/.files/shellrc ] && source ~/.files/shellrc
