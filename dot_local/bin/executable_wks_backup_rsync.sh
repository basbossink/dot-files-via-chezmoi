#!/usr/bin/env sh
set -e
if ssh-add -L | grep -q 'servers'; then
	notify-send "Backup started"
	rsync -av \
		-e 'ssh -q' \
		--delete-excluded \
		--exclude '*.pdf' \
		--exclude '*.html' \
		--exclude '*.tex' \
		--exclude '*.md' \
		--stats \
		--max-size 10mb \
		-h \
		-F \
		~/org backup:backup
	notify-send "Backup finished"
else
	notify-send -u critical "Ssh key is not loaded, skipping" >&2
	exit 1
fi
