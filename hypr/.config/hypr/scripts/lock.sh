#!/bin/sh
# Trigger the Quickshell lock. Wakes the idle lock daemon, then pokes its watch
# file (fast path) with an IPC fallback so a missed file event can never leave
# the session unlocked. The lock backdrop is the wallpaper itself, so there is
# no screen grab and no startup delay.
umask 077
dir="${XDG_RUNTIME_DIR:-/tmp}"
lockcfg="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/lockdaemon/shell.qml"

if ! qs -p "$lockcfg" ipc show >/dev/null 2>&1; then
    setsid qs -p "$lockcfg" -n -d >/dev/null 2>&1 </dev/null &
    i=0
    while [ "$i" -lt 200 ] && ! qs -p "$lockcfg" ipc show >/dev/null 2>&1; do
        sleep 0.02
        i=$((i + 1))
    done
fi

date +%s%N > "$dir/lock-trigger"
(sleep 0.3; qs -p "$lockcfg" ipc call lock lock >/dev/null 2>&1) < /dev/null &
