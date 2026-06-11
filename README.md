# Zeed Browser — AI Browser for Linux

English | [日本語](README.ja.md)

[Zeed](https://zeed.run) is a Chromium-based AI browser that reasons over your
tabs, memory, and reading context. **Linux-first**: while most AI browsers
(Comet, Atlas, Dia) ship Mac-first, Zeed ships native Linux builds as its
primary platform. Privacy by design — personal data never leaves your device,
and AI traffic goes directly from the browser to OpenRouter with your own API
key. Your Chrome extensions, bookmarks, and saved passwords carry over.

This repo is the **public distribution channel**: prebuilt binaries
(Releases tab) and packaging sources for Arch Linux (AUR), Debian/Ubuntu
(.deb), and Flatpak.

## Install

### Arch Linux (AUR)

```sh
yay -S zeed-bin        # or: paru -S zeed-bin
```

AUR package: [zeed-bin](https://aur.archlinux.org/packages/zeed-bin)

### Debian / Ubuntu (.deb)

Download `zeed-browser_<version>_amd64.deb` from the
[latest release](https://github.com/efg-technologies/zeed-browser-dist/releases/latest), then:

```sh
sudo apt install ./zeed-browser_*_amd64.deb
```

### Flatpak

Flathub submission is in progress. Until then you can build locally from the
manifest in [`flatpak/`](flatpak/README.md).

### Any distro (tarball)

Download `zeed-<version>-linux-x86_64.tar.xz` from the
[latest release](https://github.com/efg-technologies/zeed-browser-dist/releases/latest),
extract, and run `./zeed`.

### macOS (Apple Silicon)

```sh
brew install --cask efg-technologies/zeed/zeed
```

Or download the signed + notarized `.dmg` from
[v147.0.7727.55.56](https://github.com/efg-technologies/zeed-browser-dist/releases/tag/v147.0.7727.55.56),
the latest release that includes a macOS build (Linux releases ship more
frequently).

## What's here

- `packaging/aur/` — PKGBUILD + launcher + desktop entry for the `zeed-bin`
  AUR package. Source of truth; auto-pushed to
  [AUR](https://aur.archlinux.org/packages/zeed-bin) on release.
- `packaging/deb/` — `.deb` packaging (control template, maintainer scripts,
  desktop entry).
- `flatpak/` — Flathub-ready Flatpak manifest + AppStream metadata.
- `.github/workflows/publish-aur.yml` — CI that updates AUR on every release.
- `.github/workflows/publish-deb.yml` — CI that builds the `.deb` and attaches
  it to the release.
- Releases (tab above) — prebuilt Linux tarballs, `.deb` packages, and macOS
  `.dmg` images.

## How a release happens

1. Source lives in the private `efg-technologies/zeed-browser` repo.
2. Maintainer builds a production binary there and packages a tarball
   (`./packaging/scripts/make-release-tarball.sh`).
3. Maintainer runs `gh release create vX.Y.Z dist/zeed-*.tar.xz* --repo efg-technologies/zeed-browser-dist`.
4. `publish-aur.yml` here fires → bumps PKGBUILD pkgver + sha256 + pushes to AUR.
   `publish-deb.yml` builds the `.deb` and attaches it to the same release.

No application code lives in this repo. It exists only to host public binary
tarballs so that AUR users can `curl` the download URL without GitHub auth.

## Links

- Website: [zeed.run](https://zeed.run)
- AUR: [zeed-bin](https://aur.archlinux.org/packages/zeed-bin)
- Homebrew tap: [efg-technologies/homebrew-zeed](https://github.com/efg-technologies/homebrew-zeed)
- Built by [EFG Technologies Inc.](https://zeed.run) (Tokyo, Japan)
