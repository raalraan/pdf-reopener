function roz {
	local ROZDIR=~/.rz-sessions

case $1 in
  save | s)
    local ALL=$(ls -l /proc/*/fd 2>/dev/null)
    local PDFS=$(echo "$ALL" | grep .pdf$)
    local OCMD=$(echo "$PDFS" | sed -e 's/^.*-> /xdg-open "/g'\
      -e 's/$/"\>\/dev\/null 2\>\/dev\/null \&/g')
	if [[ $PDFS ]]; then
      if [[ $2 ]]; then
        echo "$OCMD" > $ROZDIR/rz-$2
		echo "$2" > $ROZDIR/last-saved
		echo "$2" > $ROZDIR/last-any
	    chmod +x $ROZDIR/rz-$2
      else
        echo "$OCMD" > $ROZDIR/rz-default
		echo "default" > $ROZDIR/last-saved
		echo "default" > $ROZDIR/last-any
	    chmod +x $ROZDIR/rz-default
      fi
	else
	  echo "Sorry, I could not find any open PDF file"
	fi
    ;;

  open | o)
    if [[ $2 ]]; then
	  if [[ $(ls $ROZDIR/rz-$2 2>/dev/null) ]]; then
        "$ROZDIR/rz-$2"
		echo "$2" > $ROZDIR/last-opened
		echo "$2" > $ROZDIR/last-any
	  else
		echo "session \"$2\" was not found"
	  fi
    else
	  if [[ $(ls $ROZDIR/rz-default 2>/dev/null) ]]; then
        "$ROZDIR/rz-default"
		echo "default" > $ROZDIR/last-opened
		echo "default" > $ROZDIR/last-any
	  else
		echo "there is no default session saved. you can save a default session"
		echo "with the argument 'save' or 's' alone and then opening with the"
		echo "argument 'open' or 'o' alone."
	  fi
    fi
    ;;

  list | ls)
    wc -l $ROZDIR/* | sed -e '$d' -e 's/ *\([^ ]*\) *\([^ ]*\)/  \2: \1 files/g' -e 's/^.*\/rz-/ /g'
	;;

  move | mv)
    if [[ $2 && $3 ]]; then
	  if [[ $(ls "$ROZDIR/rz-$2" 2>/dev/null) ]]; then
	    mv "$ROZDIR/rz-$2" "$ROZDIR/rz-$3"
	  else
		echo "session \"$2\" was not found"
	  fi
    else
	  echo "you need to provide both the current and the new name for the session"
	  echo "       roz mv 'name' 'new name'"
    fi
	;;

  remove | rm)
    if [[ $2 ]]; then
	  if [[ $(ls "$ROZDIR/rz-$2" 2>/dev/null) ]]; then
	    rm "$ROZDIR/rz-$2"
	  else
		echo "Session \"$2\" was not found"
	  fi
    else
	  echo "You need to provide the name of the session to remove"
    fi
	;;

  *)
  	echo "Use one of the following"
	echo "s, save        save a session"
	echo "o, open        open a saved session"
	echo "ls, list       show information about saved sessions"
	echo "mv, move 'name' 'new name'    rename a session"
	echo "rm, remove 'name'    remove session matching session name"
	echo "\nYou can give a name to the session by issuing the save command with a name"
	echo "        roz s my-session"
	echo "and later reopening it with the open command plus the name"
	echo "        roz o my-session"
  	;;
esac
}
