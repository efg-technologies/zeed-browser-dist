# Zeed Browser — Flatpak packaging

Flathub-ready manifest that repacks the released Linux tarball
(`zeed-<version>-linux-x86_64.tar.xz`) into a Flatpak. Same approach as
`com.brave.Browser`: freedesktop runtime + `org.chromium.Chromium.BaseApp`
(provides the `cobalt` launcher, libsecret, krb5) + `zypak` (sandbox shim
that reroutes Chromium's sandbox to `flatpak-spawn`).

## Files

| File | Purpose |
|---|---|
| `run.zeed.Browser.yml` | flatpak-builder manifest (app id from the zeed.run domain) |
| `zeed.sh` | `/app/bin/zeed` wrapper — adds `--load-extension` for the bundled AI extension, then `exec cobalt` |
| `cobalt.ini` | cobalt config — entry point, `chrome_sandbox` filename (underscore!), TreesInViz workaround |
| `run.zeed.Browser.desktop` | desktop entry (Exec/Icon renamed to Flathub conventions) |
| `run.zeed.Browser.metainfo.xml` | AppStream metadata |
| `icons/` | 128/256 px icons (the release tarball only ships `product_logo_48.png`) |
| `flathub.json` | restricts Flathub builds to x86_64 |

## Local build (Arch)

```sh
sudo pacman -S --needed flatpak flatpak-builder
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak-builder --user --install-deps-from=flathub --force-clean \
  --repo=repo builddir run.zeed.Browser.yml
flatpak --user remote-add --no-gpg-verify --if-not-exists zeed-local repo
flatpak --user install -y zeed-local run.zeed.Browser

flatpak run run.zeed.Browser
```

Headless smoke test (no display):

```sh
flatpak run --command=sh run.zeed.Browser -c '/app/zeed/zeed --version'
```

User flags go in `~/.var/app/run.zeed.Browser/config/zeed-flags.conf`
(one flag per line, `#` comments, `features+=`/`features-=` supported —
this is cobalt's flags file, equivalent to `~/.config/zeed-flags.conf`
in the AUR package).

## Version bump

1. Update `url:` + `sha256:` of the archive source in `run.zeed.Browser.yml`
   (sha256 must equal `packaging/aur/PKGBUILD` → `sha256sums_x86_64`).
2. Add a `<release>` entry in `run.zeed.Browser.metainfo.xml`.
3. After Flathub acceptance this is a PR against the
   `flathub/run.zeed.Browser` repo (CI test-builds it automatically).

## Flathub submission (maintainer, 3 steps)

1. **Replace the screenshot** in `run.zeed.Browser.metainfo.xml` (TODO
   marker) with a real in-app screenshot (1280x720+ PNG at a stable URL),
   then fork `github.com/flathub/flathub`, check out the **`new-pr`**
   branch, copy the contents of this `flatpak/` directory to the repo
   root (manifest at top level; keep `icons/`, `flathub.json`), and open
   a PR against `flathub/flathub` base branch **`new-pr`** titled
   `Add run.zeed.Browser`.
2. **Answer the review checklist** in the PR (permissions rationale:
   browser needs `--device=all`/x11/pulseaudio like Brave; binary
   redistribution is allowed because EFG Technologies owns the binaries
   and the release tarball is public). The Flathub bot test-builds the
   manifest in CI; fix anything it flags.
3. **After merge**: accept the invite to the new `flathub/run.zeed.Browser`
   repo, then verify the app on https://flathub.org/apps/run.zeed.Browser
   (Settings → verification) via DNS/well-known token on **zeed.run** —
   the app id `run.zeed.Browser` was chosen so domain verification works.

Docs: https://docs.flathub.org/docs/for-app-authors/submission
