function __tmux_rename_window_on_exec --on-event fish_preexec
    set -l pane_id (string replace -a "%" "" -- "$TMUX_PANE")
    set -l watcher_var "TMUX_WATCHER_PID_$pane_id"
    if set -q $watcher_var
        kill $$watcher_var 2>/dev/null
        set -e $watcher_var
    end

    set -l full_cmd "$argv"
    set -l target_pane "$TMUX_PANE"

    command bash -c "
        sleep 0.5 && \
        [ \"\$(tmux display-message -p -t $target_pane '#{pane_active}')\" = \"1\" ] && \
        pgrep -P $fish_pid > /dev/null && \
        tmux rename-window -t $target_pane '$(~/.config/tmux/tmux-window-rename-cmd --command-string $full_cmd)'
    " & disown

    set -g $watcher_var $last_pid
end

function __tmux_update_window_name --on-event fish_prompt
    set -l pane_id (string replace -a "%" "" -- "$TMUX_PANE")
    set -l watcher_var "TMUX_WATCHER_PID_$pane_id"

    if set -q $watcher_var
        set -l watcher_pid $$watcher_var
        kill $watcher_pid 2>/dev/null
        set -e $watcher_var
    end

    if [ (command tmux display-message -p -t $TMUX_PANE '#{pane_active}') = "1" ]
        command tmux rename-window -t $TMUX_PANE "$(~/.config/tmux/tmux-window-rename-cmd --shell-pid $fish_pid)"
    end
end

