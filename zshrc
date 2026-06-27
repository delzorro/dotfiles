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

# Set shell-mode to default / emacs (possible requirement for tmux)
bindkey -e

# Load shell indepenant settings
[ -f ~/.files/shellrc ] && source ~/.files/shellrc

# Homebrew — alleen toevoegen als aanwezig
[ -d /opt/homebrew/bin ] && export PATH=/opt/homebrew/bin:$PATH

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
# Java — alleen toevoegen als aanwezig
[ -d /opt/homebrew/opt/openjdk/bin ] && export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# NVM — lazy loading, alleen als installatie aanwezig
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  nvm()  { unset -f nvm node npm npx; \. "$NVM_DIR/nvm.sh"; nvm  "$@"; }
  node() { unset -f nvm node npm npx; \. "$NVM_DIR/nvm.sh"; node "$@"; }
  npm()  { unset -f nvm node npm npx; \. "$NVM_DIR/nvm.sh"; npm  "$@"; }
  npx()  { unset -f nvm node npm npx; \. "$NVM_DIR/nvm.sh"; npx  "$@"; }
fi

# fzf initialisatie/configuratie
if command -v fzf >/dev/null 2>&1; then
	source ~/.files/fzf.zsh
fi

# Laad de edit-command-line functie
autoload -U edit-command-line
zle -N edit-command-line

# Bind de functie aan een toets (bijv. Ctrl-x Ctrl-e)
bindkey '^x^e' edit-command-line
bindkey "^[[3~" delete-char
bindkey "^U" backward-kill-line
