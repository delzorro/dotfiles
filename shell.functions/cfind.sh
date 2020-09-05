function help { 
    echo "Usage cfind [OPTIONS] STRINGTOSEARCH 
 * Convenience function for searching for matches in code codes files. 
 * Including the following options:
   -e for file extension, default php,  
   -c remove greps coloring
   -i for case insensitive search, 
   -b for basepath, default current (.)
   -h for displaying this text" >&2
}
function cfind {
	local extension="php"
	local coloring="always"
	local insensitive=''
	local basepath="."
	local OPTIND=1
	while getopts ":e:icb:h" option; do
		case $option in
			e)
				extension=$OPTARG
				;;
			i)
				insensitive="-i"
				;;
			c)
				coloring="none"
				;;
			b)
				basepath=$OPTARG
				;;
			:)
				echo "No argument given for option ${OPTARG}" >&2
				return 2
				;;
			h|*)
				help
				return 1
				;;
		esac
	done
	shift $(($OPTIND-1))
	if [[ $# -eq 0 ]]; then
		help
		return 3
	fi

	find "${basepath}" -iname "*.${extension}" -print0 2>/dev/null | xargs -0 grep --color="${coloring}" ${insensitive} "${@}"
}
export -f cfind
