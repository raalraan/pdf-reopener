A session saver for opened PDF documents
========================================

This repository contains a zsh script that saves and opens sessions of with a
number of PDF files. It also has some abilities to manage these sessions
(list, rename, open the most recent, remove).

I often find myself with a considerable number of opened PDF files. It is
pretty uncommon for them to be on the same folder or have any other relating
feature other than that I need them at that moment. Then comes the time that I
need to close them, for whatever reason I may have. Later at some point I want
to open the same set of PDF files but I don't remember their filenames, their
paths nor the exact number of files I had. I was lost.

This script creates a zsh function, named `roz`, that uses the content of
`/proc/*/fd` to determine the name and path of opened PDF files. It then
creates a script that can be executed later with `roz open`. You can create
sessions, list them, remove them and rename them.

### Usage

If you issue the command `roz` without arguments you will see some usage
information. The available arguments are

	s, save        save a session
	o, open        open a saved session
	la, last       open the most recently saved/opened session
	ls, list       show information about saved sessions
	mv, move 'name' 'new name'    rename a session
	rm, remove 'name'             remove session matching session name

Optionally, you can name the session by providing a name of your choice

	roz s my-session

and later reopen it with the open command plus the same name

	roz o my-session

If you do not provide a name for the session it is saved under the name
`default`. This is the session that opens when you execute `roz open` or `roz
o` without extra arguments. The default session is overwritten every time you
execute `roz save` or `roz s` without a session name and some PDF files
opened. If you want to preserve the current default session but save another
default session, you can rename the current default session by using the move
command

	roz move default 'new-name'
	roz mv default 'new-name'

Where `'new-name'` is a name of your choice. Then you can have a new default
session and the old-default session can be opened by `roz o 'new-name'`

### Configuration

Currently you can configure the script trough variables contained in the
script. These variables are:

`ROZDIR`: select the folder to store the sessions and other data related to
last opened/saved session. By default it uses the directory `~/.rz-sessions`
that you need to create manually.

`LAST`: rule to determine the session to be used with the command `last`/`la`.
The options are

- `opened`: open the last session opened with the command `roz open` or `roz o`,
- `saved`: open the last session saved with the command `roz save` or `roz s`,
- `any`: open either the last saved or opened session according to which one
	was executed last.

By default the option `any` is selected. The command `last` tries to work even
if you rename the corresponding session.

`PDFVIEW`: write the command that will be used to open the PDF files. It will
be used in the sessions saved after changing it. Sessions saved before
changing it will need to be recreated (This may change in the future to always
use the chosen PDF viewer without the need to recreate sessions). The default
is `xdg-open`.
