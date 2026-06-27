# Calc enhances arithmetic capabilities of the command line, including floating point calculations by default
# @author Remco de Vos

function calc {
	awk "BEGIN { print $* }";
}

# Export function to also make it accessible in subshells
export -f calc
