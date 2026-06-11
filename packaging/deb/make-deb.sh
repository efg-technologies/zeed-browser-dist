#!/usr/bin/env bash
# Build a .deb from the Zeed release tarball.
#
# Usage: ./packaging/deb/make-deb.sh <tarball> <version> [pkgrel]
#   tarball: path to zeed-<version>-linux-x86_64.tar.xz
#   version: e.g. 147.0.7727.55.46
#   pkgrel:  debian revision (default 1)
#
# Output: $(dirname tarball)/zeed-browser_<version>-<pkgrel>_amd64.deb
#
# Runs on Debian/Ubuntu with dpkg-deb + fakeroot.
# CI: runs on ubuntu-latest.
# Arch: `yay -S dpkg fakeroot` if you need to build locally.

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <tarball> <version> [pkgrel]" >&2
  exit 1
fi

tarball="$1"
version="${2#v}"
pkgrel="${3:-1}"

if [[ ! -f "$tarball" ]]; then
  echo "error: tarball not found: $tarball" >&2
  exit 1
fi
if ! command -v dpkg-deb >/dev/null; then
  echo "error: dpkg-deb not found (install 'dpkg' package)" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "$0")" && pwd)"
out_dir="$(cd "$(dirname "$tarball")" && pwd)"
stage="$out_dir/deb-stage-$version"
deb_file="$out_dir/zeed-browser_${version}-${pkgrel}_amd64.deb"

rm -rf "$stage" "$deb_file"
mkdir -p \
  "$stage/DEBIAN" \
  "$stage/opt/zeed" \
  "$stage/usr/bin" \
  "$stage/usr/share/applications" \
  "$stage/usr/share/icons/hicolor/128x128/apps"

# Extract tarball into /opt/zeed (strip top-level zeed-<ver>-linux-x86_64/)
tar -xJf "$tarball" -C "$stage/opt/zeed" --strip-components=1

# Icon: take whatever product_logo_128.png we find in the extracted tree.
if [[ -f "$stage/opt/zeed/icons/product_logo_128.png" ]]; then
  cp "$stage/opt/zeed/icons/product_logo_128.png" \
     "$stage/usr/share/icons/hicolor/128x128/apps/zeed-browser.png"
elif [[ -f "$stage/opt/zeed/product_logo_128.png" ]]; then
  cp "$stage/opt/zeed/product_logo_128.png" \
     "$stage/usr/share/icons/hicolor/128x128/apps/zeed-browser.png"
fi

# /usr/bin/zeed-browser launcher wrapper (zeed-flags.conf, bundled
# zeed_ai extension autoload, TreesInViz workaround — same behavior as
# the AUR package), plus /usr/bin/zeed convenience symlink.
install -m 0755 "$script_dir/zeed.sh" "$stage/usr/bin/zeed-browser"
ln -sf zeed-browser "$stage/usr/bin/zeed"

# Desktop entry
cp "$script_dir/zeed-browser.desktop" \
   "$stage/usr/share/applications/zeed-browser.desktop"

# Copy DEBIAN control files (expand version in control.tmpl)
installed_kb=$(du -sk "$stage" | cut -f1)
sed -e "s|%VERSION%|${version}-${pkgrel}|g" \
    -e "s|%INSTALLED_SIZE%|${installed_kb}|g" \
    "$script_dir/control.tmpl" > "$stage/DEBIAN/control"

cp "$script_dir/postinst" "$stage/DEBIAN/postinst"
cp "$script_dir/prerm"    "$stage/DEBIAN/prerm"
chmod 0755 "$stage/DEBIAN/postinst" "$stage/DEBIAN/prerm"

# Build. Need fakeroot when not uid 0 for reproducible owner=root.
if [[ $(id -u) -eq 0 ]]; then
  dpkg-deb --build --root-owner-group "$stage" "$deb_file"
elif command -v fakeroot >/dev/null; then
  fakeroot dpkg-deb --build --root-owner-group "$stage" "$deb_file"
else
  echo "warning: non-root without fakeroot — deb may have non-zero uids" >&2
  dpkg-deb --build --root-owner-group "$stage" "$deb_file"
fi

rm -rf "$stage"

size=$(ls -lh "$deb_file" | awk '{print $5}')
sha=$(sha256sum "$deb_file" | awk '{print $1}')
sha256sum "$deb_file" > "${deb_file}.sha256"

echo ""
echo "✅ deb built:"
echo "   $deb_file ($size)"
echo "   sha256: $sha"
