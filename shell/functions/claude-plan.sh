# Initializes tmux for claude-code plan-view like behaviour
# Note: additional Claude Code instructions required to actually write and update to the plan.md file
# @author Remco de Vos

function claude-plan {

	# 1. Zorg dat plan.md lokaal bestaat
	touch plan.md

	# 2. Configureer de lokale Git-uitsluiting (als dat nog niet was gebeurd)
	if [ -d ".git" ]; then
		if ! grep -q "plan.md" .git/info/exclude 2>/dev/null; then
			echo "plan.md" >> .git/info/exclude 2>/dev/null
		fi
	fi

	# 3. Splits het tmux-venster horizontaal (rechterpaneel wordt 55% breed)
	tmux split-window -h -l 55%

	# 4. Start de geavanceerde bat-viewer in het nieuwe rechterpaneel
	tmux send-keys "vim -u ~/.files/claude/claude-plan.vimrc -R plan.md" C-m

	# 5. Switch terug naar het linkerpaneel (je actieve chatvenster)
	tmux select-pane -t 1

	# 6. Start Claude Code op in het linkerpaneel
	tmux send-keys "clear && claude" C-m
}

# Export function to also make it accessible in subshells
export -f claude-plan
