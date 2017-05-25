function roz {
	ALL=$(ls -l /proc/*/fd 2>/dev/null)
	PDFS=$(echo "$ALL" | grep .pdf$)
	echo "$PDFS"
}
