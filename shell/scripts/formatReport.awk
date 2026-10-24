#!/usr/bin/env awk -f

BEGIN {
	FS="\t"; OFS="\t"
}

/^CMT\|/ {
	split($0, parts, "|")
	cmt = parts[2]
	cmter = parts[3]
	cmterdate = parts[4]
	counter[cmter, cmterdate] += 1
	next
}

cmter != "" && NF > 2 {
	a = ($1 == "-") ? 0 : $1;
	r = ($2 == "-") ? 0 : $2;
	added[cmter, cmterdate] += a
	removed[cmter, cmterdate] += r
	next
}

/^$/ {
	cmt = ""
	cmter = ""
	cmtdaet = ""
}

END {
	for (item in counter) {
		cmts = counter[item] 
		split(item, keys, SUBSEP)
		print keys[1], keys[2], cmts, added[item], removed[item]
	}
}


