# MonoAshi

[繁體中文](README.zhhant.md) · [English](README.md) · **日本語**

![Monogatari Assistant](Title.png "Monogatari Assistant")

> 物語を書く人のためのクロスプラットフォーム執筆支援ツールです。本文、章、プロット、登場人物、世界観、アイテム、タイムラインをまとめて管理できます。

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE.md)
[![Dart](https://img.shields.io/badge/Dart-%5E3.12.1-0175C2?logo=dart)](dart_edition/pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-Material%203-02569B?logo=flutter)](dart_edition/pubspec.yaml)

## ドキュメント

[紹介サイト](https://heyairu.github.io/MonoAshi-FE/) · [紹介サイトのソース](docs/index.html) · [GitHub Pages での公開とメンテナンス](docs/WEBSITE.md)

| ドキュメント | 内容 |
| --- | --- |
| [総合ガイド](docs/GUIDE.md) | 機能、使い方、保存とバックアップ、開発環境、アーキテクチャ、リリース |
| [API リファレンス](docs/API.md) | MCP、プロジェクトファイル、Rhodanthe、Copilot アダプター、P2P、共同編集インターフェース |
| [ドキュメント一覧](docs/README.md) | 各文書の役割、バージョン情報の参照先、メンテナンス方針 |
| [参考資料一覧](docs/SOURCES.md) | 保管されているプロジェクト仕様書、利用ガイド、設計資料、リリース時の受け入れ確認資料 |

## アプリの画面

<details>
<summary>アプリの画面</summary>
<table>
<tr>
<td><img src="AppPreview/1.png" width="220" alt="アプリ画面 1"></td>
<td><img src="AppPreview/2.png" width="220" alt="アプリ画面 2"></td>
<td><img src="AppPreview/3.png" width="220" alt="アプリ画面 3"></td>
<td><img src="AppPreview/4.png" width="220" alt="アプリ画面 4"></td>
</tr>
<tr>
<td><img src="AppPreview/5.png" width="220" alt="アプリ画面 5"></td>
<td><img src="AppPreview/6.png" width="220" alt="アプリ画面 6"></td>
<td><img src="AppPreview/7.png" width="220" alt="アプリ画面 7"></td>
<td><img src="AppPreview/8.png" width="220" alt="アプリ画面 8"></td>
</tr>
</table>
</details>

## 主な機能

- 章と本文の編集、プロット、物語の設定、登場人物と相関図、世界観、用語集。
- アイテム管理、シーンの状態のスナップショット、メインタイムラインとミニタイムライン。
- 検索と置換、本文へのマーク付け、プロジェクト内のフレーズ集、校正、変更履歴の追跡。
- ローカルプロジェクト、インポートとエクスポート、自動バックアップ、ローカルネットワークでの P2P 同期、リアルタイム共同編集。
- Copilot およびローカル MCP との読み取り専用連携。Ask と Plan の利用可否はビルドフラグで決まります。Plan は提案と検証に限られます。

現在のアプリバージョンは `0.9.31`、プロジェクト XML 形式のバージョンは `1.22` です。機能ごとの制約とプラットフォーム別の検証状況は、[総合ガイド](docs/GUIDE.md)を参照してください。

## クイックスタート

メインの Flutter プロジェクトは `dart_edition/` にあり、Dart `^3.12.1` が必要です。`pubspec.yaml` の Flutter Quill の依存関係に関する注記では、Flutter 3.44 以降が必要とされています。ネイティブ版の Rhodanthe には Rust と Cargo も必要です。ツールチェーンは `dart_edition/rust/rust-toolchain.toml` を参照してください。

```powershell
cd dart_edition
flutter pub get
flutter run
```

よく使う確認コマンド

```powershell
flutter analyze
flutter test
```

Freezed または Riverpod のアノテーションを変更した場合は、次のコマンドでコードを再生成します。

```powershell
dart run build_runner build --delete-conflicting-outputs
```

フォーマット、ポリシー、Rust、リリースに関するその他の確認項目は、[開発と検証のガイド](docs/GUIDE.md#10-驗證建置與發布)を参照してください。

## ライセンスと謝辞

ソースコードは [Apache License 2.0](LICENSE.md) の下で公開されています。[NOTICE](NOTICE.md) と[商標について](TRADEMARKS.md)も参照してください。Monogatari Assistant™ とそのロゴは Heyairu（部屋伊琉）の商標です。

ロゴの制作にあたり、GitHub の Aikoyori による ProgrammingVTuberLogos を参考にしました。
