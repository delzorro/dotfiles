function help { 
    echo "Usage ffind [OPTIONS] STRINGTOSEARCH 
 * Convenience function for searching for code files. 
 * Including the following options:
   -e for file extension, default php,  
   -c remove greps coloring
   -i for case insensitive search, 
   -b for basepath, default current (.)
   -h for displaying this text" >&2
}

function ffind {

	# Declare reference parameter to hold parse result
	declare -A parsedResult

	# Parse options and arguments
	# @see find.parse.helper.sh
	findOptionsParser parsedResult "${@}"
	local RET=$?
	if [[ $RET -eq 1 || $RET -eq 3 ]]; 
	then
		help
		return $RET
	fi

	# Execute ffind
	find "${parsedResult[basePath]}" -iname "*.${parsedResult[extension]}" 2>/dev/null | grep --color="${parsedResult[coloring]}" ${parsedResult[caseInsensitive]} "${parsedResult[args]}"
}

# Export function to also make it accessible in subshells
export -f ffind
