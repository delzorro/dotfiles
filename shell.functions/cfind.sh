function help { 
    echo "Usage cfind [OPTIONS] STRINGTOSEARCH 
 * Convenience function for searching for matches in code files. 
 * Including the following options:
   -e for file extension, default php,  
   -c remove greps coloring
   -i for case insensitive search, 
   -b for basepath, default current (.)
   -h for displaying this text" >&2
}

function cfind {

	# Declare reference parameter to hold parse result
	declare -A parsedResult

	# Parse options and arguments
	# @see find.parse.helper.sh
	parseArguments parsedResult "${@}"
	local RET=$?
	if [[ $RET -eq 1 || $RET -eq 3 ]]; 
	then
		help
		return $RET
	fi

	# Execute cfind
	find "${parsedResult[basePath]}" -iname "*.${parsedResult[extension]}" -print0 2>/dev/null | xargs -0 grep --color="${parsedResult[coloring]}" ${parsedResult[caseInsensitive]} "${parsedResult[args]}"
}
export -f cfind
