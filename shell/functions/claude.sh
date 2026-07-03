# Wrapper rond het echte claude-binary: laadt secrets (o.a. GH_TOKEN) alleen in
# een subshell, zodat ze nooit in de interactieve shell zelf terechtkomen.
# @author Remco de Vos
claude() (
	# () i.p.v. {} start een subshell (fork): variabelen die hierin geëxporteerd
	# worden, lekken niet terug naar de aanroepende interactieve shell.
	set -a
	# set -a: elke volgende variabele-toekenning wordt automatisch geëxporteerd,
	# zodat een kaal "KEY=value"-bestand (zonder losse `export`-regels) toch
	# doorwerkt naar het straks ge-exec'te proces.
	[ -f ~/.secrets/claude.env ] && source ~/.secrets/claude.env
	set +a
	# set +a: export-gedrag weer uit, voor het geval hierna nog niet-geheime
	# toekenningen zouden volgen.
	exec command claude "$@"
	# exec vervangt het huidige (subshell-)proces door het echte claude-binary,
	# i.p.v. er een extra kindproces bovenop te starten. Normaal gesproken heeft
	# een shell-functie voorrang boven een PATH-executable met dezelfde naam,
	# dus zonder `command` zou "claude" hier weer deze functie zelf aanroepen
	# (oneindige recursie). De `command`-builtin dwingt de shell om functies en
	# aliases over te slaan en direct in $PATH te zoeken, zodat dit echt het
	# claude-binary aanroept.
)

# export -f claude
# Bewust uitgecomment: in bash zou dit de functie exporteren naar subshells,
# maar in zsh betekent `export -f naam` iets anders — het print de functie-
# definitie i.p.v. 'm te exporteren (geen foutmelding, maar ook geen effect).
# Bovendien is export hier niet nodig: de ()-subshell hierboven erft
# functiedefinities al automatisch van het ouderproces, in zowel bash als zsh.
