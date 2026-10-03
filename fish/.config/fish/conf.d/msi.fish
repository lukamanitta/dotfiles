# Managed by machine-setup/50-shell.sh — regenerated on each run.
# Edit machine-setup/shell/msi.fish, not this file.

set -gx MSI_CODE_ROOT "/home/luka/projects/code/msi"
set -gx GCE_INI_PATH "$MSI_CODE_ROOT/configure/gce.ini"
set -gx CLOUDSDK_PYTHON "python3"

fish_add_path "$MSI_CODE_ROOT/msi-utils/bin"
fish_add_path "/home/luka/projects/code/msi/machine-setup/bin"
fish_add_path "$HOME/bin"
fish_add_path "$HOME/.asdf/shims"
fish_add_path "$HOME/.asdf/bin"

# Google Cloud SDK shell integration (AUR google-cloud-cli locations).
for _gcloud_dir in /opt/google-cloud-sdk /usr/lib/google-cloud-sdk /usr/share/google-cloud-sdk
    if test -f "$_gcloud_dir/path.fish.inc"
        source "$_gcloud_dir/path.fish.inc"
        break
    end
end

# Install any versions declared in this directory's .tool-versions.
function msi-sync-versions --description "asdf install for the current .tool-versions"
    if test -f .tool-versions
        asdf install
    else
        echo "machine-setup: no .tool-versions in "(pwd) >&2
    end
end

alias gst="git status"
alias be="bundle exec"
alias kill-puma="pkill -USR1 puma-dev"
alias rrspec="DEPRECATION_BEHAVIOR='record' bundle exec rspec"

alias cdhms="cd /home/luka/projects/code/msi/homestay-management"
alias cde="cd /home/luka/projects/code/msi/homestay-management/executive"
alias cdr="cd /home/luka/projects/code/msi/homestay-management/reception"
alias cdl="cd /home/luka/projects/code/msi/homestay-management/lobby"
alias cdw="cd /home/luka/projects/code/msi/homestay-management/willie"
alias cdcore="cd /home/luka/projects/code/msi/hms-core"
