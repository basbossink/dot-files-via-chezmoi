#!/usr/bin/env sh
set -e

SSH_AUTH_SOCK=$(/home/bas/.cargo/bin/fd agent /tmp)
DISPLAY=:0

export SSH_AUTH_SOCK
export DISPLAY

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
		~/org \
		~/.local/bin/wks_backup_rsync.sh \
		~/ds/.local/data \
		~/.anacron/etc \
		backup:backup
	notify-send "Backup finished"
else
	notify-send -u critical "Ssh key is not loaded, skipping" >&2
	exit 1
fi
