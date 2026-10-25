#!/usr/bin/env bash

set -euo pipefail

usage() {
	local SCRIPTNAME=$(basename $0)
	echo "Usage $SCRIPTNAME <ticket.1>,<ticket.2>,...,<ticket.n>" >&2
	echo "Example $SCRIPTNAME PAR-1234,PAR-2345,par-3456" >&2
}

getTicketArgs() {
	local TICKETS="$@"
	local PATTERN=""
	while IFS= read -r ticket; do
		[[ -z "$ticket" ]] && continue
		if [[ -n "$PATTERN" ]]; then
			PATTERN+="|"
		fi
		PATTERN+="$ticket"
	done < <(printf '%s\n' $TICKETS | tr ',' '\n')
	echo "$PATTERN"
}

getGitLog() {
	local TICKET_PATTERN="$1"
	shift
	git log \
		--reverse \
		--numstat \
		--date=short \
		--pretty=format:'CMT|%h|%cn [%ce]|%cd' \
		--extended-regexp \
		--grep="$TICKET_PATTERN" \
		"$@"
}

git-ticket-report() {

	# Tool presence check 
	if ! command -v git; then
	   echo "Command `git` not found, but required" >&2
	   return 1	   
	fi

	# Repos presence check
	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	   echo "Not inside a git-repos" >&2
	   return 1
	fi

	# Do argument check
	if [[ $# -lt 1 || $1 == "-h" || $1 == "--help" ]]; then
		usage
		return 1
	fi

	# Tool presence validation
	if ! command -v git; then
	   echo "Command `git` not found, but required" >&2
	   return 1	   
	fi

	# Split input parameters
	local TICKETS=$1
	shift

	# Prepare grep-pattern
	local TICKET_EXPR=$(getTicketArgs "$TICKETS")

	# Get according git-log
	local GIT_LOG=$(getGitLog "$TICKET_EXPR" "$@")

	# Process output to report
	echo "$GIT_LOG"
}

# Execute function
GIT_LOG=$(git-ticket-report "$@")

# Zoek de map van dit script op (werkt ook via symlinks in ~/bin)
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Format the report
"$SCRIPT_DIR/formatReport.awk" <(echo "$GIT_LOG")  \
	| sort -t $'\t' -k1,1 -k2,2 \
	| awk -F'\t' '$1 != prev { print $1; prev = $1 }
		{ printf "- %s: %3dx, %5d toegevoegd, %5d verwijderd\n", $2, $3, $4, $5}'

