# CLUE — Claude Local Unified Experience
# Start Claude Code in een gesplitst tmux-venster met plan.md preview rechts.
# Note: vereist een ~/.claude/CLAUDE.md die Claude instrueert plan.md bij te houden.
# @author Remco de Vos

function clue {

	# 0. Bepaal het te gebruiken plan-document
	#    - Met argument: die naam (zonder .md); dubbele extensie wordt voorkomen.
	#    - Zonder argument: <git-branch>-plan.md (slashes → '-' zodat het een
	#      plat bestand blijft), of 'plan.md' als er geen branch/repo is.
	local PLAN_DOC
	if [ -n "$1" ]; then
		PLAN_DOC="${1%.md}.md"
	else
		local branch
		branch=$(git branch --show-current 2>/dev/null)
		if [ -n "$branch" ]; then
			PLAN_DOC="${branch//\//-}-plan.md"
		else
			PLAN_DOC="plan.md"
		fi
	fi

	# 1. Zorg dat het plan-document lokaal bestaat
	touch "$PLAN_DOC"

	# 1b. Deel de gekozen naam met Claude via een window-scoped tmux-optie
	#     (runtime-state, geen env-vervuiling of extra bestand op disk)
	tmux set-option -w @plan_doc "$PLAN_DOC" 2>/dev/null

	# 2. Configureer de lokale Git-uitsluiting (als dat nog niet was gebeurd)
	if [ -d ".git" ]; then
		if ! grep -qxF "$PLAN_DOC" .git/info/exclude 2>/dev/null; then
			echo "$PLAN_DOC" >> .git/info/exclude 2>/dev/null
		fi
	fi

	# 3. Splits het tmux-venster horizontaal (rechterpaneel wordt 55% breed)
	RIGHT_PANE=$(tmux split-window -h -l 55% -P -F '#{pane_id}')
	tmux set-hook -w window-resized "resize-pane -t $RIGHT_PANE -x 55%"

	# 4. Start de markdown viewer in het nieuwe rechterpaneel
	tmux send-keys "nvim -u ~/.files/claude/claude-plan.nvimrc -R $PLAN_DOC" C-m

	# 5. Switch terug naar het linkerpaneel (je actieve chatvenster)
	tmux select-pane -t 1

	# 6. Start Claude Code op in het linkerpaneel
	tmux send-keys "clear && claude" C-m
}

# Export function to also make it accessible in subshells
export -f clue
