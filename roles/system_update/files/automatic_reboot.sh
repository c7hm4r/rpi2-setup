#!/bin/bash

# Parameters

# - FAILED_REBOOT_SINCE_FILE
# - FAILED_URGENT_REBOOT_SINCE_FILE

# - FAILED_REBOOT_TIMEOUT
# - FAILED_URGENT_REBOOT_TIMEOUT
# - TIME_TO_LOG_OUT

# - NO_RESTART_NEEDED_OUTPUT
# - REBOOT_WALL_MESSAGE
# - REBOOT_DEFERRED_MESSAGE

set -e
set -x

function set_file_contents() {
	local file_path=$1
	local contents=$2
	mkdir -p "$(dirname "$1")"
	echo "$contents" >"$file_path"
}

function reboot_required() {
	! checkrestart | grep -q "$NO_RESTART_NEEDED_OUTPUT"
}

function urgent_reboot_required() {
	[ -f /var/run/reboot-required ]
}

function update_reboot_required_file() {
	local reboot_required_command=$1
	local FAILED_REBOOT_SINCE_FILE=$2
	local current_date=$3
	local FAILED_REBOOT_TIMEOUT=$4

	if "$reboot_required_command"; then
		if [ ! -f "$FAILED_REBOOT_SINCE_FILE" ]; then
			set_file_contents "$FAILED_REBOOT_SINCE_FILE" "$current_date"
		fi
		if (($(cat "$FAILED_REBOOT_SINCE_FILE") + FAILED_REBOOT_TIMEOUT <= current_date)); then
			reboot=1
		else
			reboot_deferred=1
		fi
	else
		rm "$FAILED_REBOOT_SINCE_FILE" || true
	fi
}

# if no restart required ...
if ! reboot_required; then
	exit
fi

current_date=$(date +%s)
unset reboot
unset reboot_deferred

# if someone is logged in
if [ -n "$(who)" ]; then
	# TODO Set SSH Banner if not already done

	update_reboot_required_file urgent_reboot_required "$FAILED_URGENT_REBOOT_SINCE_FILE" "$current_date" "$FAILED_URGENT_REBOOT_TIMEOUT"
	update_reboot_required_file reboot_required "$FAILED_REBOOT_SINCE_FILE" "$current_date" "$FAILED_REBOOT_TIMEOUT"
	if [ -n "$reboot" ]; then
		rm "$FAILED_REBOOT_SINCE_FILE" || true
		rm "$FAILED_URGENT_REBOOT_SINCE_FILE" || true
		shutdown -r "+$TIME_TO_LOG_OUT" "$REBOOT_WALL_MESSAGE"
	elif [ -n "$reboot_deferred" ]; then
		echo "$REBOOT_DEFERRED_MESSAGE" | wall
	fi
else
	rm "$FAILED_REBOOT_SINCE_FILE" || true
	rm "$FAILED_URGENT_REBOOT_SINCE_FILE" || true
	shutdown -r now
fi
