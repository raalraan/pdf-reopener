function roz {
	ALL=$(ls -l /proc/*/fd 2>/dev/null)
	PDFS=$(echo "$ALL" | grep .pdf$)
	OCMD=$(echo "$PDFS" | sed -e 's/^.*-> /xdg-open "/g'\
		-e 's/$/"\>\/dev\/null 2\>\/dev\/null \&/g')
	echo "$OCMD"
}
