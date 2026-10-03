# CLUE — Claude Local Unified Experience
# Start Claude Code in een gesplitst tmux-venster met plan.md preview rechts.
# Note: vereist een ~/.claude/CLAUDE.md die Claude instrueert plan.md bij te houden.
# Gebruik: clue [identifier] [-- <claude-opties>]
#          clue --resume [identifier] [-- <claude-opties>]
# @author Remco de Vos

function clue {

	# 0. Parse argumenten; alles na '--' is voor claude en gaat ongezien door
	local id="" resume=""
	case "$1" in
		--resume|-r)
			resume=1
			shift
			if [ $# -gt 0 ] && [ "$1" != "--" ]; then
				id="$1"
				shift
			fi
			;;
		--|"") ;;
		-*)
			echo "clue: gebruik '--' voor claude-opties: clue [identifier] -- $1" >&2
			return 1
			;;
		*)
			id="$1"
			shift
			;;
	esac
	if [ "$1" = "--" ]; then
		shift
	elif [ $# -gt 0 ]; then
		echo "clue: onverwacht argument '$1' — gebruik: clue [--resume] [identifier] [-- <claude-opties>]" >&2
		return 1
	fi
	if [ -z "$TMUX_PANE" ]; then
		echo "clue: werkt alleen binnen tmux" >&2
		return 1
	fi
	id="${id%.md}"
	id="${id#plan-}"
	case "$id" in
		*[!A-Za-z0-9._-]*)
			echo "clue: identifier mag alleen letters, cijfers en . _ - bevatten: '$id'" >&2
			return 1
			;;
	esac

	# 1. Sessie bepalen. clue houdt zelf bij welke sessie-id bij welke
	#    identifier hoort (per repo; de laatste regel wint).
	local root register uuid
	root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
	register="${XDG_STATE_HOME:-$HOME/.local/state}/clue/sessions"
	if [ -n "$resume" ]; then
		if [ -z "$id" ]; then
			_clue_list "$root" "$register"
			return 0
		fi
		uuid=$(awk -F'\t' -v r="$root" -v i="$id" '$1 == r && $2 == i { u = $3 } END { print u }' "$register" 2>/dev/null)
		if [ -z "$uuid" ]; then
			echo "clue: geen sessie '$id' bekend in $root" >&2
			_clue_list "$root" "$register" >&2
			return 1
		fi
	else
		uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
		[ -n "$id" ] || id="${uuid:0:8}"
		mkdir -p "${register%/*}"
		printf '%s\t%s\t%s\n' "$root" "$id" "$uuid" >> "$register"
	fi

	# 2. Plan-document in de repo-root
	local plan="$root/plan-$id.md"
	touch "$plan"

	# 3. Viewer rechts (55%); het nvim-commando wordt getypt, zodat het in de
	#    historie van dat paneel staat
	local right_pane
	right_pane=$(tmux split-window -h -l 55% -c "$root" -P -F '#{pane_id}')
	tmux set-hook -w window-resized "resize-pane -t $right_pane -x 55%"
	tmux send-keys -t "$right_pane" "nvim -u ~/.files/claude/claude-plan.nvimrc -R $(printf '%q' "$plan")" C-m
	tmux select-pane -t "$TMUX_PANE"

	# 4. Claude Code in dit paneel; -n toont de identifier in de --resume-lijst
	clear
	if [ -n "$resume" ]; then
		claude --resume "$uuid" -n "$id" --append-system-prompt "Plan document for this session: $plan" "$@"
	else
		claude --session-id "$uuid" -n "$id" --append-system-prompt "Plan document for this session: $plan" "$@"
	fi
}

# Bekende identifiers in deze repo, meest recent onderaan
function _clue_list {
	echo "Bekende clue-sessies in $1:"
	awk -F'\t' -v r="$1" '$1 == r { last[$2] = NR } END { for (i in last) print last[i], i }' "$2" 2>/dev/null \
		| sort -n | cut -d' ' -f2- | sed 's/^/  /'
}

# Export function to also make it accessible in subshells
export -f clue
