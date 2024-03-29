# don't put duplicate lines in the history
setopt HIST_IGNORE_ALL_DUPS
# .. or lines starting with space in the history.
setopt HIST_IGNORE_SPACE

# Share history between sessions, append to history file after shell exists
setopt APPEND_HISTORY

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=10000
export HISTSIZE=10000

# Prompt settings; mainly what I'm used to in bash, including a little extra
PROMPT='[%(?:%F{010}✔:%F{red}✗)%f]' # exit status last action
PROMPT+='%F{010}%n@%m%F{015}:' # user@machine
PROMPT+='%F{039}%(5~|%-1~/…/%3~|%4~)%F{015}»%f ' # current directory notation, in which long paths are trimmed down
#PROMPT+='$(git_prompt_info)' # I find this not really necessary

# Default fzf zsh-izzle
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load shell indepenant settings
[ -f ~/.files/shellrc ] && source ~/.files/shellrc

# Local / MacOS addition for brew
export PATH=/opt/homebrew/bin:$PATH

function sudo {
	local firstArg=$1
	if [[ $(type $firstArg) =~ "function" ]]
	then
		shift && command sudo zsh -c "$(declare -f $firstArg); SSTP_VPN_PID=$SSTP_VPN_PID; $firstArg $*"
	else
		command sudo "$@"
	fi
}
alias sudo='sudo '
