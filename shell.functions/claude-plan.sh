# Initializes tmux for claude-code plan-view like behaviour
# Note: additional Claude Code instructions required to actually write and update to the plan.md file
# @author Remco de Vos

function claude-plan {

	# 1. Zorg dat plan.md lokaal bestaat
	touch plan.md

	# 2. Configureer de lokale Git-uitsluiting (als dat nog niet was gebeurd)
	if [ -d ".git" ]; then
		git add -N plan.md 2>/dev/null
		if ! grep -q "plan.md" .git/info/exclude 2>/dev/null; then
			echo "plan.md" >> .git/info/exclude 2>/dev/null
		fi
	fi

	# 3. Splits het tmux-venster horizontaal (rechterpaneel wordt 55% breed)
	tmux split-window -h -p 55

	# 4. Start de geavanceerde bat-viewer in het nieuwe rechterpaneel
	# Inclusief Git-wijzigingen, regelnummers, paging en automatische loop
	#tmux send-keys "bat --loop --paging=always --wrap=character --style=numbers,changes plan.md" C-m
	#echo plan.md | entr -c bat --paging=never --wrap=character --style=numbers,changes plan.md
	#tmux send-keys "echo plan.md | entr -s 'tput cup 0 0 && tput ed && bat --paging=never --wrap=character --style=numbers,changes plan.md && tput cup 0 0'" C-m
	#tmux send-keys "view +set\ autoread plan.md" C-m
	#tmux send-keys "vim plan.md" C-m
	#tmux send-keys "bat --color=always --style=numbers,changes plan.md | less -r --follow-name" C-m
	#tmux send-keys "nvim -R -c 'set autoread updatetime=300 | autocmd CursorHold,BufEnter,FocusGained * checktime' plan.md" C-m
	#tmux send-keys "nvim -R -c 'syntax on | set ft=markdown | set autoread | call timer_start(500, {-> execute(\"checktime\")}, {\"repeat\": -1})' plan.md" C-m
	#tmux send-keys "vim -R -c 'syntax on | set ft=markdown | set autoread | call timer_start(500, {-> execute(\"checktime\")}, {\"repeat\": -1})' plan.md" C-m
	#tmux send-keys "vim -R -c 'syntax on | set ft=markdown | set termguicolors | set conceallevel=2 | set autoread | call timer_start(500, {-> execute(\"checktime\")}, {\"repeat\": -1})' plan.md" C-m
	tmux send-keys "vim -u ~/.files/claude/claude-plan.vimrc -R plan.md" C-m

	# 5. Switch terug naar het linkerpaneel (je actieve chatvenster)
	tmux select-pane -t 1

	# 6. Start Claude Code op in het linkerpaneel
	tmux send-keys "clear && claude --permission-mode plan" C-m
}

# Export function to also make it accessible in subshells
export -f claude-plan
