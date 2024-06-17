function initializeSstpPidVar {
	local currSetting=

	if [[ ! -z $SSTP_VPN_PID ]]
	then 
		currSetting=$SSTP_VPN_PID
	fi
	export SSTP_VPN_PID=$currSetting
}
initializeSstpPidVar

# sstp-client connection to office
function startSstpVpn {

	[[ -n $SSTP_VPN_PID ]] && echo "Currently process ${SSTP_VPN_PID} is running" 2>&1 && return 3

	# Should be run as root
	if [[ `whoami` != 'root' ]]; then
		echo "${0} should be run as root" 1>&2
		return 1;
	fi

	local usage="Function for connecting to an SSTP VPN
Usage: ${0} [OPTIONS|FLAGS]
Options/flag are:
 -u,--username <username> *	- provide the concerning username
 -t,--targeturl <targeturl> *	- provide the VPN URL
 -h				- flag to displaying this text
 *) mandatory";

	# -D pulls parsed flags out of $@
	# -E allows flags/args and positionals to be mixed, which we don't want in this example
	# -F says fail if we find a flag that wasn't defined
	# -M allows us to map option aliases (ie: h=flag_help -help=h)
	# -K allows us to set default values without zparseopts overwriting them
	zmodload zsh/zutil
	zparseopts -D -K -F -- \
		{h,-help}=flag_help \
		{t,-target}:=targeturl \
		{u,-username}:=uname;

	if [[ -z $targeturl || -z $uname || ! -z $flag_help ]]
	then
		print -l $usage 2>&1
		return 2;
	fi
		
	PASSWD=$(read -s "?Wachtwoord VPN account:"; echo $REPLY)

	#/opt/homebrew/Cellar/sstp-client/1.0.18/sbin/sstpc --log-level 2 --log-stderr --cert-warn --user "${UNAME}" --password "${PASSWD}" "${TARGETURL}" usepeerdns require-mschap-v2 noauth noipdefault defaultroute refuse-eap noccp &
	#/opt/homebrew/Cellar/sstp-client/1.0.18/sbin/sstpc --log-level 2 --log-stderr --cert-warn --user "${uname[2]}" --password "${PASSWD}" "${targeturl[2]}" usepeerdns require-mschap-v2 noauth noipdefault nodefaultroute refuse-eap noccp &
	/opt/homebrew/Cellar/sstp-client/1.0.18_1/sbin/sstpc --log-level 2 --log-stderr --cert-warn --user "${uname[2]}" --password "${PASSWD}" "${targeturl[2]}" usepeerdns require-mschap-v2 noauth noipdefault nodefaultroute refuse-eap noccp &
	export SSTP_VPN_PID=$!
	echo $'\n'"PID: $SSTP_VPN_PID"

	sleep 3
	# remote defaultroute option, and have traffic meant for office routed through
	route add -net 192.168.0.0/16 -interface ppp0
	route add -net 10.19.0.0/16 -interface ppp0
	route add -net 185.6.160.222/24 -interface ppp0
	route add -net 213.51.64.66/24 -interface ppp0
	route add -net 192.168.0.0/24 -interface ppp0
}

# Export function to also make it accessible in subshells
export -f startSstpVpn

function closeSstpVpn {

	# Should be run as root
	if [[ `whoami` != 'root' ]]; then
		echo "${0} should be run as root" 1>&2
		return 1;
	fi

	# Check if running
	if [[ ! $SSTP_VPN_PID -gt 0 ]]
	then
		echo "No VPN (PID) found" 2>&1
		return 1
	fi

	# Kill it
	kill -9 $SSTP_VPN_PID

	# Adminstration
	export SSTP_VPN_PID=
}

# Export function to also make it accessible in subshells
export -f closeSstpVpn
