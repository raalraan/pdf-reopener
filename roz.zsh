# Save and reopen sessions of PDF files
#
# Copyright © 2017 Raymundo A. Ramo <raalraan@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

function roz {
	local ROZDIR=~/.rz-sessions
	# Rule to determine the most recent session:
	# 'opened': 'last' command opens last session opened by roz open/o
	# 'saved': 'last' command opens last session saved by roz save/s
	# 'any': 'last' command opens last session saved or opened
	local LAST=any
	local PDFVIEW=xdg-open

case $1 in
  save | s)
    local ALL=$(ls -l /proc/*/fd 2>/dev/null)
    local PDFS=$(echo "$ALL" | grep .pdf$)
	if [[ $PDFS ]]; then
      local OCMD=$(echo "$PDFS" | sed -e "s/^.*-> /$PDFVIEW \"/g"\
        -e 's/$/"\>\/dev\/null 2\>\/dev\/null \&/g')
      if [[ $2 ]]; then
        echo "$OCMD" > $ROZDIR/rz-$2
		echo "$2" > $ROZDIR/.last-saved
		echo "$2" > $ROZDIR/.last-any
	    chmod +x $ROZDIR/rz-$2
      else
        echo "$OCMD" > $ROZDIR/rz-default
		echo "default" > $ROZDIR/.last-saved
		echo "default" > $ROZDIR/.last-any
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
		echo "$2" > $ROZDIR/.last-opened
		echo "$2" > $ROZDIR/.last-any
	  else
		echo "session \"$2\" was not found"
	  fi

    else
	  if [[ $(ls $ROZDIR/rz-default 2>/dev/null) ]]; then
        "$ROZDIR/rz-default"
		echo "default" > $ROZDIR/.last-opened
		echo "default" > $ROZDIR/.last-any
	else
		echo "there is no default session saved. you can save a default session"
		echo "with the argument 'save' or 's' alone and then opening with the"
		echo "argument 'open' or 'o' alone."
	  fi
    fi
    ;;

  last | la)
	if [[ $(ls "$ROZDIR/.last-$LAST" 2>/dev/null) ]]; then
	  LSTSES=$(cat "$ROZDIR/.last-$LAST")
	  if [[ $(ls "$ROZDIR/rz-$LSTSES" 2>/dev/null) ]]; then
		echo "Opening session '$LSTSES'"
        "$ROZDIR/rz-$LSTSES"
      else
        echo "The most recently opened/saved session '$LSTSES' seems to be not present"
	  fi
	else
	  echo "There is no last session on record (rule: $LAST)"
	fi
	;;

  list | ls)
    wc -l $ROZDIR/* | sed -e '$d' -e 's/ *\([^ ]*\) *\([^ ]*\)/  \2: \1 files/g' -e 's/^.*\/rz-/ /g'
	;;

  move | mv)
    if [[ $2 && $3 ]]; then
	  if [[ $(ls "$ROZDIR/rz-$2" 2>/dev/null) ]]; then
		# Avoid losing the 'last' ability when renaming the most recently
		# opened/saved session
		if [[ "$2" = "$(cat "$ROZDIR/.last-$LAST")" ]]; then
          mv "$ROZDIR/rz-$2" "$ROZDIR/rz-$3"
		  echo "$3" > "$ROZDIR/.last-$LAST"
		else
          mv "$ROZDIR/rz-$2" "$ROZDIR/rz-$3"
		fi
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
	echo "la, last       open the most recently saved/opened session"
	echo "ls, list       show information about saved sessions"
	echo "mv, move 'name' 'new name'    rename a session"
	echo "rm, remove 'name'    remove session matching session name"
	echo "\nYou can name the session by issuing the save command with the name"
	echo "        roz s my-session"
	echo "and later reopening it with the open command plus the name"
	echo "        roz o my-session"
  	;;
esac
}
