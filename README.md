# MonoAshi

[繁體中文](README.zhhant.md) · **English** · [日本語](README.ja.md)

![Monogatari Assistant](Title.png "Monogatari Assistant")

> A cross-platform writing assistant for storytellers. Keep your manuscript, chapters, outline, characters, worldbuilding, items, and timelines in one place.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE.md)
[![Dart](https://img.shields.io/badge/Dart-%5E3.12.1-0175C2?logo=dart)](dart_edition/pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-Material%203-02569B?logo=flutter)](dart_edition/pubspec.yaml)

## Documentation

[Website](https://heyairu.github.io/MonoAshi-FE/) · [Promotional website source](docs/index.html) · [Publishing and maintaining the GitHub Pages site](docs/WEBSITE.md)

| Document | Contents |
| --- | --- |
| [User and developer guide](docs/GUIDE.md) | Features, workflows, saving and backups, development setup, architecture, and releases |
| [API reference](docs/API.md) | MCP, project files, Rhodanthe, the Copilot adapter, P2P, and collaboration interfaces |
| [Documentation hub](docs/README.md) | Document scope, version sources, and maintenance guidelines |
| [Reference index](docs/SOURCES.md) | Archived project specifications, user guides, design documents, and release acceptance documents |

## App Preview

<details>
<summary>App Preview</summary>
<table>
<tr>
<td><img src="AppPreview/1.png" width="220" alt="App preview 1"></td>
<td><img src="AppPreview/2.png" width="220" alt="App preview 2"></td>
<td><img src="AppPreview/3.png" width="220" alt="App preview 3"></td>
<td><img src="AppPreview/4.png" width="220" alt="App preview 4"></td>
</tr>
<tr>
<td><img src="AppPreview/5.png" width="220" alt="App preview 5"></td>
<td><img src="AppPreview/6.png" width="220" alt="App preview 6"></td>
<td><img src="AppPreview/7.png" width="220" alt="App preview 7"></td>
<td><img src="AppPreview/8.png" width="220" alt="App preview 8"></td>
</tr>
</table>
</details>

## Features

- Chapter and manuscript editing, outlines, story settings, characters and relationship diagrams, worldbuilding, and terminology.
- Item management, scene state snapshots, a main timeline, and micro-timelines.
- Find and replace, manuscript annotations, a project phrase library, proofreading, and revision tracking.
- Local projects, import and export, automatic backups, P2P sync over a local network, and real-time collaboration.
- Read-only integration with Copilot and local MCP. Build flags control availability of Ask and Plan. Plan is limited to proposals and validation.

The current app version is `0.9.31`, and the project XML format version is `1.22`. See the [guide](docs/GUIDE.md) for feature limitations and platform validation status.

## Quick Start

The main Flutter project is in `dart_edition/` and requires Dart `^3.12.1`. The Flutter Quill dependency note in `pubspec.yaml` specifies Flutter 3.44 or later. Native Rhodanthe also requires Rust and Cargo. See `dart_edition/rust/rust-toolchain.toml` for the toolchain.

```powershell
cd dart_edition
flutter pub get
flutter run
```

Common checks

```powershell
flutter analyze
flutter test
```

After changing Freezed or Riverpod annotations, regenerate the code with the following command.

```powershell
dart run build_runner build --delete-conflicting-outputs
```

See the [development and verification guide](docs/GUIDE.md#10-驗證建置與發布) for additional formatting, policy, Rust, and release checks.

## License and Acknowledgments

The source code is licensed under the [Apache License 2.0](LICENSE.md). See also [NOTICE](NOTICE.md) and the [trademark policy](TRADEMARKS.md). Monogatari Assistant™ and its logo are trademarks of Heyairu (部屋伊琉).

The logo was inspired by ProgrammingVTuberLogos by Aikoyori on GitHub.
