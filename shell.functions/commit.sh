# Commit implements my svn workflow;
# - it makes up the (initial) list of files to commit in a temporary file (assuming files are (A)dded to svn if necessary)
#   (source is either the current (working) directory, or the result from the pipe)
# - then the svn file list is opened in vim for further investigation / alteration
# - the final file list is then used for committing to svn, with a vim pop-up to provide a commit message
# - afterwards the in-between temporary file is removed
# @author Remco de Vos
function commit {
	tmpFile=$(mktemp /tmp/commit.XXXXXX)
	if [[ -t 0 ]] ; then
		svn stat | grep -vEi '^[?| ]' > "$tmpFile" # Everything not starting with a ? or space
	else 
		cat - > "$tmpFile"
	fi
	vim "${tmpFile}"
	svn ci --force-interactive $(cat "${tmpFile}" | sed 's/+/ /' | awk '{print $2}')
	rm "${tmpFile}";
}
export -f commit
