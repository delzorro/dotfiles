#!/usr/bin/env bash

set -euo pipefail

# Calc enhances arithmetic capabilities of the command line, including floating point calculations by default
# @author Remco de Vos

usage() {
	local SCRIPTNAME=$(basename $0)
	echo "Usage $SCRIPTNAME <mathematical expresssion>" >&2
	echo "Example $SCRIPTNAME 1/3" >&2
}

function calc {
	if [[ $# -eq 0 ]]; then
		usage;
		return 1;
	fi

	awk "BEGIN { print $* }";
}

calc "$@"
