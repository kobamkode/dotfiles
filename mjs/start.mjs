#!/usr/bin/env zx

// Switch to workspace 2 and launch Firefox
await $`ydotool << EOF
key 125:1 2:1 2:0 125:0
EOF`;
await sleep(1000);
await $`setsid -f flatpak run org.mozilla.firefox > /dev/null 2>&1`;
await sleep(1000);

// Switch to workspace 3 and launch DBeaver
await $`ydotool << EOF
key 125:1 3:1 3:0 125:0
EOF`;
await sleep(1000);
await $`setsid -f flatpak run io.dbeaver.DBeaverCommunity > /dev/null 2>&1`;
await sleep(6000);

// Switch to workspace 4 and launch Spotify
await $`ydotool << EOF
key 125:1 4:1 4:0 125:0
EOF`;
await sleep(1000);
await $`setsid -f flatpak run com.spotify.Client > /dev/null 2>&1`;
await sleep(1000);

// Open tmux in current terminal
await $`ydotool << EOF
key 125:1 1:1 1:0 125:0
EOF`;
await sleep(1000);
await $({ stdio: 'inherit' })`tmux`;
