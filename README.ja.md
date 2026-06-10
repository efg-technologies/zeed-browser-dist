# Zeed Browser — Linux 向け AI ブラウザ

[English](README.md) | 日本語

[Zeed](https://zeed.run) は Chromium ベースの AI ブラウザです。開いているタブ・
メモリ・閲覧コンテキストを横断して AI が推論します。**Linux ファースト**:
多くの AI ブラウザ (Comet, Atlas, Dia) が Mac 優先の中、Zeed は Linux ネイティブ
ビルドを主要プラットフォームとして出荷しています。プライバシー重視の設計で、
個人データは端末の外に出ません。AI 通信は自分の API キーでブラウザから
OpenRouter へ直接送られます。Chrome の拡張機能・ブックマーク・保存済み
パスワードはそのまま引き継げます。

このリポジトリは **公開配布チャネル** です: ビルド済みバイナリ (Releases タブ)
と、Arch Linux (AUR) / Debian・Ubuntu (.deb) / Flatpak のパッケージングソースを
置いています。

## インストール

### Arch Linux (AUR)

```sh
yay -S zeed-bin        # または: paru -S zeed-bin
```

AUR パッケージ: [zeed-bin](https://aur.archlinux.org/packages/zeed-bin)

### Debian / Ubuntu (.deb)

[最新リリース](https://github.com/efg-technologies/zeed-browser-dist/releases/latest)
から `zeed-browser_<version>_amd64.deb` をダウンロードして:

```sh
sudo apt install ./zeed-browser_*_amd64.deb
```

### Flatpak

Flathub への登録は準備中です。それまでは [`flatpak/`](flatpak/README.md) の
マニフェストからローカルビルドできます。

### その他のディストリビューション (tarball)

[最新リリース](https://github.com/efg-technologies/zeed-browser-dist/releases/latest)
から `zeed-<version>-linux-x86_64.tar.xz` をダウンロードし、展開して `./zeed`
を実行してください。

### macOS (Apple Silicon)

```sh
brew install --cask efg-technologies/zeed/zeed
```

または[最新リリース](https://github.com/efg-technologies/zeed-browser-dist/releases/latest)
から署名・公証済みの `.dmg` をダウンロードしてください。

## リポジトリの内容

- `packaging/aur/` — `zeed-bin` AUR パッケージの PKGBUILD + ランチャー +
  デスクトップエントリ。ここが正で、リリースごとに
  [AUR](https://aur.archlinux.org/packages/zeed-bin) へ自動 push されます。
- `packaging/deb/` — `.deb` パッケージング (control テンプレート、
  メンテナスクリプト、デスクトップエントリ)。
- `flatpak/` — Flathub 対応の Flatpak マニフェスト + AppStream メタデータ。
- `.github/workflows/publish-aur.yml` — リリースごとに AUR を更新する CI。
- Releases (上のタブ) — ビルド済み Linux tarball / `.deb` / macOS `.dmg`。

## リリースの流れ

1. ソースは private の `efg-technologies/zeed-browser` リポジトリにあります。
2. メンテナがそこで production バイナリをビルドし、tarball を作成
   (`./packaging/scripts/make-release-tarball.sh`)。
3. メンテナが `gh release create vX.Y.Z dist/zeed-*.tar.xz* --repo efg-technologies/zeed-browser-dist` を実行。
4. このリポジトリの `publish-aur.yml` が起動 → PKGBUILD の pkgver + sha256 を
   更新して AUR へ push。

このリポジトリにアプリケーションコードはありません。AUR ユーザーが GitHub
認証なしでダウンロード URL を `curl` できるよう、公開バイナリ tarball を
ホストするためだけに存在します。

## リンク

- 公式サイト: [zeed.run](https://zeed.run)
- AUR: [zeed-bin](https://aur.archlinux.org/packages/zeed-bin)
- Homebrew tap: [efg-technologies/homebrew-zeed](https://github.com/efg-technologies/homebrew-zeed)
- 開発・配布: [EFG Technologies Inc.](https://zeed.run) (東京)
