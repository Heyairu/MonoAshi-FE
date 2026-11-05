# Rust 實作與工具鏈規劃

本規劃以現有 Rhodanthe 為範圍：先確保 Windows／Linux／macOS 的原生分析引擎能重現建置，再依量測結果改善分析效能，最後完成行動平台封裝。Flutter 繼續負責 UI、IME、狀態與 fallback；Rust 負責可獨立測試的文字運算。

## 現況與責任邊界

| 層級 | 現有實作 | 後續責任 |
| --- | --- | --- |
| `rhodanthe-core` | UTF-16 範圍驗證、Ring 仲裁、文件 revision、原子編輯、render plan | 保持平台無關；新增能力先在此定義資料不變條件 |
| `rhodanthe-analyzers` | 一般／regex 搜尋、贅詞 trie、合併分析與預算 | 以輸入大小、結果上限與基準測試約束成本 |
| `rhodanthe-bridge` | JSON 協定、五個 C ABI 函式、opaque handle、panic containment | 保持 ABI 穩定、明確 buffer 所有權、協定能力協商 |
| Dart infrastructure | FFI、長駐 worker、latest-only、deadline、render 驗證、rollout guard | 接入編輯器並拒絕過期結果；原生失敗時維持 Dart fallback |

已有功能不另行重寫。新分析能力依序經過 core／analyzer 單元測試、bridge 協定測試、Dart FFI／worker 測試，最後才接上 UI。

## 工具鏈設定

目前保留 `rust-toolchain.toml` 的 **Rust 1.75.0**、minimal profile、`rustfmt` 與 `clippy`，edition 為 2021，workspace MSRV 為 1.75。版本升級另開變更，同時驗證鎖檔、所有相依套件與三個桌面平台；不將升級混入功能開發。

1. 依 [rustup 官方安裝說明](https://rust-lang.github.io/rustup/installation/other.html) 安裝 rustup，確認其 bin 目錄已在 PATH。
2. 準備原生 linker：Windows 使用 MSVC C++ Build Tools 與 Windows SDK；Linux 使用系統 C/C++ linker；macOS 使用 Xcode／Command Line Tools。Flutter App 另外需要各平台的 Flutter 建置相依套件。
3. 進入 Rust workspace 後執行以下命令。rustup 會依工具鏈檔安裝指定版本與元件，不需要修改全域預設版本。

```sh
cd dart_edition/rust
rustup show
cargo --version
rustc --version
cargo fmt --all --check
cargo clippy --locked --workspace --all-targets -- -D warnings
cargo test --locked --workspace
cargo build --locked --release -p rhodanthe-bridge
```

`Cargo.lock` 必須提交。一般檢查、建置與 CI 使用 `--locked`，相依更新才刻意重建鎖檔。首次建置需要網路；快取完整後可在 Cargo 命令加上 `--offline`。

工具鏈由工作目錄向上尋找；僅從 repo 根目錄加上 `--manifest-path`，不能保證 rustup 選到巢狀 workspace 的版本。既有編譯腳本與 CMake 都在 `rust/` 執行 Cargo。[rustup 規則](https://rust-lang.github.io/rustup/overrides.html)也允許環境變數或使用者 override 優先；版本不符時先檢查 `rustup show active-toolchain` 與 `RUSTUP_TOOLCHAIN`。

可在 VS Code 開啟 `dart_edition/rust` 使用 rust-analyzer；從 repo 根目錄開啟時，將 `dart_edition/rust/Cargo.toml` 加入 rust-analyzer 的 linked projects。

## 統一編譯與檢查入口

先在 `dart_edition/` 執行 `flutter pub get`，再使用既有 Dart 編譯工具：

```sh
cd dart_edition

# 先檢視命令，不執行 Cargo 或建立輸出目錄。
dart run tool/build_rhodanthe_native.dart --dry-run

# 預設為目前桌面平台、Release；可用 --debug 改為 Debug。
dart run tool/build_rhodanthe_native.dart

# 指定交叉目標；需事先安裝 target 並設定 linker／SDK。
dart run tool/build_rhodanthe_native.dart --platform android-arm64 --dry-run

# 編譯後驗證真實 FFI 與長駐 worker。
flutter test test/rhodanthe_native_client_test.dart test/rhodanthe_worker_executor_test.dart
```

腳本使用鎖檔、在 Rust workspace 執行 Cargo，並將 Cargo 輸出固定在 `rust/target`，避免 `CARGO_TARGET_DIR` 改變位置後複製不到產物。`--out` 指定 staging 目錄，`--cargo` 可指定 Cargo 執行檔；腳本本身可用絕對路徑從其他工作目錄呼叫。相對 `--out` 以呼叫端目錄解讀。`--platform` 不會自動配置交叉編譯環境；跨桌面系統時必須明確指定 `--target`。

編譯工具結束碼：參數錯誤 64、缺少產物 66、無法啟動 Cargo 69、檔案操作失敗 74；Cargo 本身失敗則保留其結束碼。Cargo 的 `build.target`／`CARGO_BUILD_TARGET` 會影響產物子目錄，使用自訂目標時請同時傳入 `--target`。

FFI 測試預設尋找目前桌面平台的 `rust/target/release` 產物；沒有 Rust 的一般 Flutter 開發環境仍可略過原生生命週期測試。CI 設定 `RHODANTHE_NATIVE_LIBRARY` 為剛編譯完成的絕對路徑；設定後若檔案不存在，測試會失敗，避免把跳過誤當通過。

Windows／Linux App 建置會透過 CMake 自動編譯與安裝原生庫。macOS Universal App 沿用 `tool/build_macos_rhodanthe.sh`，詳見 [PACKAGING.md](PACKAGING.md)。單獨 staging 原生庫不等於完成 App 封裝。

## 分階段實作與驗收

| 階段 | 工作 | 完成條件 |
| --- | --- | --- |
| P0：重現建置 | 鎖定工具鏈與相依、統一產物路徑、參數錯誤處理、三桌面 Rust CI、Linux 真實 FFI／worker 測試 | 三平台 fmt／clippy／test／Release build 通過；Linux FFI 不跳過；乾淨 checkout 可依文件重建 |
| P1：效能與運算邊界 | 沿用 `benchmark/RHODANTHE.md` 測量搜尋、贅詞、JSON 與 span 轉換，記錄文件大小、p50／p95 與記憶體；只針對瓶頸優化 | UTF-16、revision、結果上限與 fallback 行為不變；目標裝置分析 p95 符合既有 75 ms gate；不阻塞 UI isolate |
| P2：平台封裝 | Android 設定 NDK linker 與各 ABI；iOS 完成 static library 的 Xcode 連結與符號保留；各桌面驗證最終安裝包 | 每種支援架構都從已封裝的 App 完成 ABI handshake、開啟／編輯／分析／關閉，並驗證缺庫 fallback |
| P3：新原生能力 | 依產品需求擴充 analyzer；用 capability 協商接入；沿用 Shadow → Search → Full → default-on 發布流程 | Dart／Rust 一致性、失敗預算與 rollout evidence 過關，再發布新能力 |

本次變更提供 P0 的腳本與 CI 設定；CI 尚須在遠端實際通過，Windows／macOS 安裝包驗收仍屬 P2。P1～P3 是後續工作，並未因新增 CI 而完成。

Linux P2 已完成本機 AppImage 建置及封裝內原生庫驗證：由產出的 AppImage 抽出 `.so`，確認 checksum 與 Release 產物相同，並通過 ABI、handshake、UTF-16 搜尋與文件開啟／編輯／分析／關閉流程。其他平台封裝、GUI 操作與缺庫 fallback 驗收仍須分別執行。

實作時維持以下約束：

- UI isolate 不直接呼叫同步 FFI；使用長駐 worker。
- 所有 editor offset 為 UTF-16 code unit；不以 UTF-8 byte offset 直接回傳 Dart。
- timeout／latest-only 僅停止等待與發布，不能中斷已在執行的 native call。若量測需要真正取消，再設計 analyzer 協作式取消與獨立 cancellation handle，不能只放寬 timeout。
- 不開啟 `panic = "abort"`，避免破壞現有 C ABI 的 panic containment；LTO、strip、codegen-units 等 release 調校先以效能與符號驗證為依據。
- 不在同一 engine 被呼叫時釋放 handle；response buffer 僅釋放一次。ABI／JSON contract 變更必須同步更新 header、協定 DTO 與相容性測試。

## 自動驗證

[`rhodanthe-native.yml`](../../.github/workflows/rhodanthe-native.yml) 在 Windows、Linux、macOS 執行 pinned-toolchain 的格式、Clippy、測試及 Release bridge 建置；Linux 額外以 Flutter 執行真實 FFI 與 worker 測試。這個工作流程驗證 host 原生庫，尚未涵蓋 Universal／行動平台交叉編譯、完整 App 封裝、簽署或公證。

2026-11-05 本機 Linux x86_64 驗證：Rust 1.75.0 的 fmt、Clippy、55 個 workspace 測試、Release bridge 編譯與 staging 通過；Dart 靜態分析與 4 個真實 FFI／worker 測試通過且未跳過。另檢查命令列錯誤、跨目錄呼叫、含空白的 staging 路徑、環境輸出路徑覆寫與產物 checksum。初次驗證使用 `/tmp/monogatari-rust-validation` 的隔離 Rust；後續 AppImage 建置故障排除已將 Rust 1.75.0、rustfmt 與 Clippy 持久安裝至使用者 `~/.cargo`／`~/.rustup`。AppImage 腳本會自動偵測此位置；在終端使用其他 Cargo 命令前，可執行 `. "$HOME/.cargo/env"`。
