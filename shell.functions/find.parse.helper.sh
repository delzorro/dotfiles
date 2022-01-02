#
# This function parses the (same) options/arguments for both cfind and ffind
#
function findOptionsParser {

	# First argument is assumed to be the parse result variable
	declare -n result=$1
	shift 1

	# Actual parsing options and arguments
	local extension="php"
	local coloring="always"
	local caseInsensitive=''
	local basePath="."
	local OPTIND=1

	while getopts ":e:icb:h" option; do
		case $option in
			e)
				extension=$OPTARG
				;;
			i)
				caseInsensitive="-i"
				;;
			c)
				coloring="none"
				;;
			b)
				basePath=$OPTARG
				;;
			:)
				echo "No argument given for option ${OPTARG}" >&2
				return 2
				;;
			h|*)
				return 1
				;;
		esac
	done
	shift $(($OPTIND-1))
	if [[ $# -eq 0 ]]; then
		return 3
	fi

	# Set result variable with parsed result
	result=([extension]=$extension [caseInsensitive]=$caseInsensitive [coloring]=$coloring [basePath]=$basePath [args]="${@}" ) 
}
