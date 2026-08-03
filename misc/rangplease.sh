#!/bin/bash

LOCAL_MIRROR_DIR="${HOME}/university/cosc7502/mirrors/rangpur"
CLANGD_CACHE_DIR="${HOME}/university/cosc7502/.clangd_cache"
STUDENT_ID=s4697584
REMOTE_HOST="rangpur"

REMOTE_USER_DIR="/home/Student/${STUDENT_ID}"
LOCAL_USER_DIR="${LOCAL_MIRROR_DIR}${REMOTE_USER_DIR}"

mount() {
    ACTION=$1

    mkdir -p "$LOCAL_USER_DIR"

    if [ "$ACTION" == "up" ]; then
        echo "Mounting $REMOTE_HOST workspace..."
        sshfs "${REMOTE_HOST}:${REMOTE_USER_DIR}" "$LOCAL_USER_DIR" \
            -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
        echo "Mounted at $LOCAL_USER_DIR"

    elif [ "$ACTION" == "down" ]; then
        echo "Unmounting $REMOTE_HOST workspace..."
        # Forcefully unmount to clear the connection [cite: 92]
        fusermount -uz "$LOCAL_USER_DIR"
        echo "Unmounted safely."

    else
        echo "Usage: ./rangplease.sh mount [up|down]"
    fi
}

mirror_headers() {
    LOCAL_PROJECT_DIR=$1
    SERVER_COMPILE_COMMANDS_JSON=$2

    echo "Parsing include paths from $SERVER_COMPILE_COMMANDS_JSON..."

    INCLUDES=$(jq -r '.[].arguments[]' "$SERVER_COMPILE_COMMANDS_JSON" | \
               awk '/^-I$/ {getline; print; next} /^-I/ {print substr($0, 3)}' | \
               sort -u)

    echo "Found the following unique external dependencies:"
    echo "$INCLUDES"

    for REMOTE_DIR in $INCLUDES; do
        # Only rsync directories that are OUTSIDE the user workspace
        if [[ "$REMOTE_DIR" != "$REMOTE_USER_DIR"* ]]; then
            LOCAL_TARGET="${LOCAL_MIRROR_DIR}${REMOTE_DIR}"

            if [ ! -d "$LOCAL_TARGET" ]; then
                echo "Mirroring missing dependency: $REMOTE_DIR"
                mkdir -p "$LOCAL_TARGET"
                rsync -az --info=progress2 --copy-links "${REMOTE_HOST}:${REMOTE_DIR}/" "${LOCAL_TARGET}/"
            fi
        fi
    done

    echo "Sync complete! Your local cache is ready at: $LOCAL_MIRROR_DIR"
}

localise_compile_commands() {
    LOCAL_PROJECT_DIR=$1
    PROJECT_CLANGD_CACHE_DIR=$2

    SERVER_COMPILE_COMMANDS_JSON=$3
    CACHE_COMPILE_COMMANDS_JSON=$4

    echo "Copying compile_commands.json to local cache..."
    cp "$SERVER_COMPILE_COMMANDS_JSON" "$CACHE_COMPILE_COMMANDS_JSON"

    echo "Rewriting paths for local clangd resolution..."

    sed -i "s|\"/|\"$LOCAL_MIRROR_DIR/|g" "$CACHE_COMPILE_COMMANDS_JSON"

    sed -i "s|-I/|-I$LOCAL_MIRROR_DIR/|g" "$CACHE_COMPILE_COMMANDS_JSON"

    sed -i "s|-isystem/|-isystem$LOCAL_MIRROR_DIR/|g" "$CACHE_COMPILE_COMMANDS_JSON"

    echo "Localised compile_commands.json ready at $CACHE_COMPILE_COMMANDS_JSON"
}

write_nvim_config() {
    LOCAL_PROJECT_DIR=$1
    PROJECT_CLANGD_CACHE_DIR=$2

    NVIM_CONFIG_FILE="${LOCAL_PROJECT_DIR}/.nvim.lua"
    if [ ! -f "$NVIM_CONFIG_FILE" ]; then
        echo "Creating Neovim config for clangd..."
        cat <<EOL > "$NVIM_CONFIG_FILE"
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--compile-commands-dir=${PROJECT_CLANGD_CACHE_DIR}",
    },
})
EOL
        echo "Neovim config created at $NVIM_CONFIG_FILE"
        cat "$NVIM_CONFIG_FILE"
    else
        echo "Neovim config already exists at $NVIM_CONFIG_FILE. Skipping creation."
    fi
}

sync_project() {
    REMOTE_PROJECT_DIR=$1
    LOCAL_PROJECT_DIR="$LOCAL_USER_DIR/$REMOTE_PROJECT_DIR"

    if [ ! -d "$LOCAL_PROJECT_DIR" ]; then
        echo "Error: Project directory $LOCAL_PROJECT_DIR does not exist. Is it mounted?"
        exit 1
    fi

    PROJECT_CLANGD_CACHE_DIR="$CLANGD_CACHE_DIR/$REMOTE_PROJECT_DIR"
    mkdir -p "$PROJECT_CLANGD_CACHE_DIR"

    SERVER_COMPILE_COMMANDS_JSON="$LOCAL_PROJECT_DIR/compile_commands.json"

    if [ ! -f "$SERVER_COMPILE_COMMANDS_JSON" ]; then
        echo "Error: compile_commands.json not found in $LOCAL_PROJECT_DIR"
        exit 1
    fi

    CACHE_COMPILE_COMMANDS_JSON="$PROJECT_CLANGD_CACHE_DIR/compile_commands.json"

    mirror_headers "$LOCAL_PROJECT_DIR" "$SERVER_COMPILE_COMMANDS_JSON"
    localise_compile_commands "$LOCAL_PROJECT_DIR" "$PROJECT_CLANGD_CACHE_DIR" "$SERVER_COMPILE_COMMANDS_JSON" "$CACHE_COMPILE_COMMANDS_JSON"
    write_nvim_config "$LOCAL_PROJECT_DIR" "$PROJECT_CLANGD_CACHE_DIR"
}

if [ "$1" == "mount" ]; then
    mount "$2"
elif [ "$1" == "sync-project" ]; then
    if [ -z "$2" ]; then
        echo "Error: Please specify the project directory to sync."
        exit 1
    fi
    sync_project "$2"
else
    echo "Usage: ./rangplease.sh [mount up|mount down|sync-project <project_dir>]"
fi
