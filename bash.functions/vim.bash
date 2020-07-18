# Vim gives the message "Input is not from a terminal" when it's called in combination with xargs in a pipe
# (@see this post for more information https://superuser.com/questions/336016/invoking-vi-through-find-xargs-breaks-my-terminal-why)
# Below function act as mediator to the vim program:
# * normal use with command line arguments -> revert to (normal) call to vim with given arguments
# * usage in a pipe -> 'fixed' call to vim 
#  -> based on above mentioned post, and 
#  -> altered to also include command line options (for example -p, to open files in tabs)
# @author Remco de Vos

function vim {
	local POSOPTARGS="$@" 
	if [[ -t 0 ]] ; then
		# stdin is a tty: process command line
		/usr/bin/env vim $POSOPTARGS 
	else 
		# stdin is not a tty: process standard input
		xargs sh -c '</dev/tty /usr/bin/env vim "$@"' zero $POSOPTARGS 
	fi
}

# Export function to also make it accessible in subshells
export -f vim
