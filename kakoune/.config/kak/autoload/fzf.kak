# 'Find' user mode
declare-user-mode find
map global user f ":enter-user-mode find<ret>" -docstring "enter find mode"

define-command -hidden -docstring "run a fzf command and save output to tmp file" \
run-fzf-cmd -params .. %{
    suspend-and-resume \
        "%arg{@} > /tmp/fzf-files-%val{client_pid}" \
        "for-each-line edit /tmp/fzf-files-%val{client_pid}"
}

declare-option str fzf_grep_cmd 'rg --line-number . | fzf --delimiter=\":\" --preview \"fzf-grep-preview {1} {2}\" | sed \"s|\\([^:]*\\):\\([^:]*\\):.*|\\1 \\2|\"'
map global find g ":run-fzf-cmd '%opt{fzf_grep_cmd}'<ret>" -docstring "find by file content"

map global find f ":run-fzf-cmd 'fzf'<ret>" -docstring "find filenames"
