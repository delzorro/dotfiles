# CLUE — Claude Local Unified Experience
# Start Claude Code in een gesplitst tmux-venster met plan.md preview rechts.
# Note: vereist een ~/.claude/CLAUDE.md die Claude instrueert plan.md bij te houden.
# @author Remco de Vos

function clue {

	# 1. Zorg dat plan.md lokaal bestaat
	touch plan.md

	# 2. Configureer de lokale Git-uitsluiting (als dat nog niet was gebeurd)
	if [ -d ".git" ]; then
		if ! grep -q "plan.md" .git/info/exclude 2>/dev/null; then
			echo "plan.md" >> .git/info/exclude 2>/dev/null
		fi
	fi

	# 3. Splits het tmux-venster horizontaal (rechterpaneel wordt 55% breed)
	RIGHT_PANE=$(tmux split-window -h -l 55% -P -F '#{pane_id}')
	tmux set-hook -w window-resized "resize-pane -t $RIGHT_PANE -x 55%"

	# 4. Start de markdown viewer in het nieuwe rechterpaneel
	tmux send-keys "nvim -u ~/.files/claude/claude-plan.nvimrc -R plan.md" C-m
	# tmux send-keys "vim -u ~/.files/claude/claude-plan.vimrc -R plan.md" C-m
	# tmux send-keys "presenterm plan.md" C-m
	# tmux send-keys "echo plan.md | entr sh -c 'tmux clear-history; clear; glow plan.md'" C-m

	# 5. Switch terug naar het linkerpaneel (je actieve chatvenster)
	tmux select-pane -t 1

	# 6. Start Claude Code op in het linkerpaneel
	tmux send-keys "clear && claude" C-m
}

# Export function to also make it accessible in subshells
export -f clue
