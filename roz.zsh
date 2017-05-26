function roz {
case $1 in
  catch | c)
    ALL=$(ls -l /proc/*/fd 2>/dev/null)
    PDFS=$(echo "$ALL" | grep .pdf$)
    OCMD=$(echo "$PDFS" | sed -e 's/^.*-> /xdg-open "/g'\
      -e 's/$/"\>\/dev\/null 2\>\/dev\/null \&/g')
    if [[ $2 ]]; then
      echo "$OCMD\nto rz-$2"
    else
      echo "$OCMD\nto rz-default"
    fi
    ;;

  open | o)
    if [[ $2 ]]; then
	  if [[ $(ls ~/.rz-sessions/rz-$2 2>/dev/null) ]]; then
        echo "will execute rz-$2"
	  else
		echo "Session \"$2\" was not found"
	  fi
    else
	  if [[ $(ls ~/.rz-sessions/rz-default 2>/dev/null) ]]; then
        echo "will execute rz-default"
	  else
		echo "There is no default session saved. You can save a default session"
		echo "with the argument 'catch' or 'c' alone and then opening with the"
		echo "argument 'open' or 'o' alone."
	  fi
    fi
    ;;

  list | ls)
    wc -l ~/.rz-sessions/* | sed -e '$d' -e 's/\/home\/.*\.rz-sessions\/rz-//g' -e 's/ *\([^ ]*\) *\([^ ]*\)/  \2: \1 files/g'
	;;

  move | mv)
    if [[ $2 && $3 ]]; then
	  if [[ $(ls ~/.rz-sessions/rz-$2 2>/dev/null) ]]; then
	    echo "will rename session $2 to $3: mv ~/.rz-sessions/rz-$2 ~/.rz-sessions/rz-$3"
	  else
		echo "Session \"$2\" was not found"
	  fi
    else
	  echo "You need to provide both the current and the new name for the session"
	  echo "       roz mv 'name' 'new name'"
    fi
	;;

  remove | rm)
    if [[ $2 ]]; then
	  if [[ $(ls ~/.rz-sessions/rz-$2 2>/dev/null) ]]; then
	    echo "will remove session $2: rm ~/.rz-sessions/rz-$2"
	  else
		echo "Session \"$2\" was not found"
	  fi
    else
	  echo "You need to provide the name of the session to remove"
    fi
	;;

  *)
  	echo "Use one of the following"
	echo "c, catch       save a session"
	echo "o, open        open a saved session"
	echo "ls, list       show information about saved sessions"
	echo "mv, move 'name' 'new name'    rename a session"
	echo "rm, remove 'name'    remove session matching session name"
	echo "\nYou can give a name to the session by issuing the catch command with a name"
	echo "        roz c my-session"
	echo "and later reopening it with the open command plus the name"
	echo "        roz o my-session"
  	;;
esac
}
