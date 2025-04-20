
#!/usr/bin/env bash

function get_status {
    echo "📦 Restic backup status:"
    systemctl --user status restic-backup.service --no-pager | head -n 10

    if systemctl --user is-active --quiet restic-backup.service; then
        echo "🟢 Backup is currently running."

        # Get main PID of the service
        pid=$(systemctl --user show -p MainPID --value restic-backup.service)
        if [ "$pid" -ne 0 ]; then
            start_time=$(ps -p "$pid" -o lstart=)
            elapsed=$(ps -p "$pid" -o etime=)
            echo "🕒 Started at: $start_time"
            echo "⏱️  Elapsed time: $elapsed"

            # Check how much data has been written to the repo so far
            repo_dir="$HOME/.cache/restic"  # Or wherever your repo cache is
            cache_size=$(du -sh "$repo_dir" 2>/dev/null | cut -f1)
            echo "📂 Cache size (repo-related): $cache_size"
        fi
    else
        echo "🔴 Backup is not currently running."
    fi
}

# Main
get_status
read -p "Would you like to start a backup right now (y/n)? " choice
case "$choice" in
    y|Y)
        systemctl --user start restic-backup.service
        get_status
        ;;
esac
