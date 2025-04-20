#!/usr/bin/env bash

function get_status {
    echo "Restic backup status: "
    systemctl --user status restic-backup.service
}


get_status

read -p "Would you like to start a backup right now (y/n)?" choice
case "$choice" in
    y|Y)
        systemctl --user start restic-backup.service
        get_status

esac
