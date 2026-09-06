#!/bin/bash
KITTY_PID=$(hyprctl activewindow -j | jq -r '.pid')
SOCKET="unix:@kitty-${KITTY_PID}"

WINDOW_JSON=$(kitten @ --to "$SOCKET" ls | jq -r '.[0].tabs[0].windows[0]')
WINDOW_ID=$(echo "$WINDOW_JSON" | jq -r '.id')
CONTAINER_ID=$(echo "$WINDOW_JSON" | jq -r '.foreground_processes[].cmdline[]' | grep '^--env=CONTAINER_ID=' | head -n1 | cut -d= -f3)

if [ -n "$CONTAINER_ID" ]; then
    CWD_FILE="$HOME/.cache/kitty-cwd-${WINDOW_ID}"
    CWD=$(cat "$CWD_FILE" 2>/dev/null || echo "$HOME")
    kitten @ --to "$SOCKET" launch --type=os-window -- \
        distrobox enter "$CONTAINER_ID" -- zsh -c "cd '$CWD' && exec zsh"
else
    CWD=$(echo "$WINDOW_JSON" | jq -r '.cwd')
    kitten @ --to "$SOCKET" launch --type=os-window --copy-env --cwd="$CWD"
fi
