# zeed-browser-dist

Public distribution channel for [Zeed browser](https://github.com/efg-technologies/zeed-browser).

## What's here

- `packaging/aur/` — PKGBUILD + launcher + desktop entry for the `zeed-bin` AUR
  package. Source of truth; auto-pushed to
  [AUR](https://aur.archlinux.org/packages/zeed-bin) on release.
- `.github/workflows/publish-aur.yml` — CI that updates AUR on every release.
- Releases (tab above) — prebuilt `zeed-<version>-linux-x86_64.tar.xz` tarballs.

## Install

```
yay -S zeed-bin
```

## How a release happens

1. Source lives in the private `efg-technologies/zeed-browser` repo.
2. Maintainer builds a production binary there and packages a tarball
   (`./packaging/scripts/make-release-tarball.sh`).
3. Maintainer runs `gh release create vX.Y.Z dist/zeed-*.tar.xz* --repo efg-technologies/zeed-browser-dist`.
4. `publish-aur.yml` here fires → bumps PKGBUILD pkgver + sha256 + pushes to AUR.

No code lives in this repo. It exists only to host public binary tarballs so
that AUR users can `curl` the download URL without GitHub auth.
