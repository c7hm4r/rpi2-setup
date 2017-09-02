#!/bin/bash

# Parameters

# - failed_reboot_since_file
# - failed_urgent_reboot_since_file

# - failed_reboot_timeout
# - failed_urgent_reboot_timeout
# - time_to_log_out

# - no_restart_needed_output
# - reboot_wall_message
# - reboot_deferred_message


function set_file_contents()
{
    local file_path=$1
    local contents=$2
    mkdir -p "$(dirname "$1")"
    echo "$contents" > "$file_path"
}

function reboot_required()
{
    ! checkrestart | grep -q "$no_restart_needed_output"
}

function urgent_reboot_required()
{
    [ -f /var/run/reboot-required ]
}

function update_reboot_required_file()
{
    local reboot_required_command=$1
    local failed_reboot_since_file=$2
    local current_date=$3
    local failed_reboot_timeout=$4

    if "$reboot_required_command"
    then
        if [ ! -f "$failed_reboot_since_file" ]
        then
            set_file_contents "$failed_reboot_since_file" "$current_date"
        fi
        if (( "$(cat "$failed_reboot_since_file")" + "$failed_reboot_timeout" <= "$current_date" ))
        then
            reboot=1
        fi
    else
        rm "$failed_reboot_since_file" || true
    fi
}

# if no restart required ...
if ! reboot_required
then
    exit
fi

current_date=$(date +%s)
unset reboot

# if someone is logged in
if [ -n "$(who)" ]
then
    # TODO Set SSH Banner if not already done

    update_reboot_required_file urgent_reboot_required "$failed_urgent_reboot_since_file" "$current_date" "$failed_urgent_reboot_timeout"
    update_reboot_required_file reboot_required "$failed_reboot_since_file" "$current_date" "$failed_reboot_timeout"
    if [ -n "$reboot" ]
    then
        wall "$reboot_wall_message"
        sleep "$time_to_log_out"
    else
        wall "$reboot_deferred_message"
    fi
else
    reboot=1
fi

if [ -n "$reboot"]
then
    rm "$failed_reboot_since_file" || true
    rm "$failed_urgent_reboot_since_file" || true
    systemctl reboot
fi
