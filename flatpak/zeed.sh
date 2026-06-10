#!/bin/sh
# /app/bin/zeed — Flatpak launcher for Zeed browser.
#
# Cobalt (from org.chromium.Chromium.BaseApp) handles zypak, the user
# flags file (~/.var/app/run.zeed.Browser/config/zeed-flags.conf) and
# desktop integration. See /app/etc/cobalt.ini for its configuration.

# Auto-load the bundled Zeed AI extension so the sidebar works out of
# the box. Opt out with ZEED_SKIP_BUNDLED_EXTENSION=1 (same knob as the
# AUR package launcher).
ZEED_BUNDLED_EXT=/app/zeed/bundled_extensions/zeed_ai
if [ -d "$ZEED_BUNDLED_EXT" ] && [ -z "${ZEED_SKIP_BUNDLED_EXTENSION:-}" ]; then
  set -- --load-extension="$ZEED_BUNDLED_EXT" "$@"
fi

exec cobalt "$@"
