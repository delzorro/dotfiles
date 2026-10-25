#!/usr/bin/env bash

# Geen pipefail: de exitcode is die van grep (wel/geen treffer), ook als find onleesbare mappen tegenkomt
set -eu

# Searches for code files based on given options and search criteria
source "$(dirname "$(readlink -f "$0")")/finders.rc"

finders_parse ffind 'Convenience function for searching for code files based on given search criteria' "$@"
find "${basePath}" -iname "*.${extension}" -print 2>/dev/null | grep --color="${coloring}" ${caseInsensitive} "${pattern[@]}"
