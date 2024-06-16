# Define file find constant
readonly FILE_FIND='ffind'

# Define code find constant
readonly CODE_FIND='cfind'

#
# This method displays the usage of the requested code finder
#
function help { 
	methodName=${1-"[${CODE_FIND}|${FILE_FIND}]"}
	description='Convenience functions for searching for/through code files based on given search criteria'
	declare -A descriptions
	descriptions[$CODE_FIND]='Convenience function for searching through code files based on given search criteria'
	descriptions[$FILE_FIND]='Convenience function for searching for code files based on given search criteria'
	if [[ ! -z "${descriptions[$methodName]}" ]]; then
		description=${descriptions[$methodName]}
	fi

	# Usage
    echo "Usage ${methodName} [BASEPATH] [OPTIONS] STRINGTOSEARCH 
 * ${description}. 
 * Base path defaults to current directory, if not given.
 * Supported options are:
   -e for file extension, default php,  
   -C remove greps coloring
   -i for case insensitive search, 
   -h for displaying this text" >&2
}

#
# This function parses the options/arguments and runs the requested find method
#
function findHelper {

	# Check method support
	local findMethod="${1-"No method"}"
	local supportedMethods=($CODE_FIND $FILE_FIND)
	[[ ! ${supportedMethods[@]} =~ ${findMethod} ]] && {
		echo "${findMethod} is not supported." >&2	
		return 1
	}
	shift 1

	# Options/arguments are expected
	[[ "$#" -eq 0 ]] && {
		help $findMethod
		return 1	
	}

	# Handle a non-option base path at first
	# - if non-option 
	#   - if a directory -> OK
	#   - if not a directory && more arguments -> erronous call
	basePath="."
	if [[ ! "$1" =~ '-[a-zA-Z]' ]]; then
		if [[ -d $1 ]]; then
			basePath="$1"
			shift 1
		elif [[ ! -d $1 && "$#" -gt 1 ]]; then 
			echo "$1 is not a directory" >&2
			help $findMethod
			return 1
		fi
	fi

	# Parse option arguments with getopts
	local extension="php"
	local coloring="always"
	local caseInsensitive=''
	local OPTIND=1
	while getopts ":e:iCh" option; do
		case $option in
			e)
				extension=$OPTARG
				;;
			i)
				caseInsensitive="-i"
				;;
			C)
				coloring="none"
				;;
			h)
				help $findMethod
				return 1
				;;
			:)
				echo "No argument given for option ${OPTARG}" >&2
				return 2
				;;
			?)
				echo "Option ${OPTARG} is not supported" >&2
				return 2
				;;
		esac
	done
	shift $(($OPTIND-1))
	if [[ $# -eq 0 ]]; then
		help $findMethod
		return 3
	fi

	# Execute method
	if [[ $findMethod == $CODE_FIND ]]; then 
		find "${basePath}" -iname "*.${extension}" -print0 2>/dev/null | xargs -0 grep --color="${coloring}" ${caseInsensitive} "${@}"
	else # FILE_FIND
		find "${basePath}" -iname "*.${extension}" -print0 2>/dev/null | grep -z --color="${coloring}" ${caseInsensitive} "${@}"
	fi
}

# Export function to also make it accessible in subshells
export -f findHelper

# This method searches through code files based on given options and search criteria
function cfind {
	findHelper $CODE_FIND "${@}"
}

# Export function to also make it accessible in subshells
export -f cfind

# This method searches for code files based on given options and search criteria
function ffind {
	findHelper $FILE_FIND "${@}"
}

# Export function to also make it accessible in subshells
export -f ffind
