#!/usr/bin/env bash

# Geen pipefail: de exitcode is die van grep (wel/geen treffer), ook als find onleesbare mappen tegenkomt
set -eu

# Searches through code files based on given options and search criteria
source "$(dirname "$(readlink -f "$0")")/finders.rc"

finders_parse cfind 'Convenience function for searching through code files based on given search criteria' "$@"
find "${basePath}" -iname "*.${extension}" -print0 2>/dev/null | xargs -0 grep --color="${coloring}" ${caseInsensitive} "${pattern[@]}"
