# i18n 與 Localization 實作規劃

更新日期：2026-11-02
狀態：P1 語系基礎、P2 共用操作與 P3 功能模組已實作；P4 已補齊三語完整離線說明、共用日期／數字格式與字型政策；原生發布資源另行驗收。P5 語言審校與原生多平台實機驗收仍是發布工作。
第一階段語言：**繁體中文、英文、日文**（使用者已確認）。

已落地：`gen-l10n`／ARB、語系解析、系統跟隨、即時切換、本機偏好、依序寫入與失敗回復、UI 字型與 Quill 繁中 adapter，以及 OOBE 首頁／標題／導覽和一般設定相關文案。三個 App 分支共用 delegate 與解析規則。後續已完成其餘 OOBE、Ribbon、導覽、檔案／編輯操作及功能模組文案，三語 ARB 各 2,344 筆；三語 Help 各有完整 64 篇、167 個章節、258 段內文與 230 個步驟，切換語系會更新快取。實際功能範圍見 [GUIDE.md](GUIDE.md)。

語言在 OOBE 透過共用選單直接寫入 SettingsStateNotifier，獨立於 `OobePreferences` 的完成草稿；不再把語言複製進草稿，避免完成引導時用舊值覆蓋較新的即時選擇。

生成工具鏈備註：本機 Dart 3.13 SDK 與既有 analyzer 7.6.0／Freezed 2.5.8 的一般 `build_runner` 解析遇到 `Missing implementation of visitDotShorthandPropertyAccess`。本次使用相同鎖定的 Freezed，在暫存環境以未改動的 model 與最小外部型別宣告產生 `app_state_data.freezed.dart`，再以實際 App 依賴進行編譯、分析與測試；沒有手改生成檔或升級相依。一般全專案 Freezed 重建仍需另外解決 SDK／generator 相容性，不能將本次功能測試視為該工具鏈問題已修復。

P1 驗證紀錄：語系解析、儲存、切換、OOBE、設定版面、導覽、主題及 Help 的 111 項組合測試，以及正式 MainApp 分支 2 項、三語窄螢幕／200% 縮放 3 項，合計 116 項通過。全專案靜態分析為 0 error／0 warning，另有 183 項風格 info；變更檔格式檢查通過。初始化政策工具仍報出 5 處：`main.dart` 的寫作進度初始化與 listener 片段，以及 `writing_goal_dialog.dart` 的三個專案／目標讀取；均非本次新增的語系初始化讀取。因此不宣稱整條既有 CI pipeline 已通過。

P2–P4 驗證（2026-11-02）：完整 Flutter 回歸 1,324 項通過、4 項略過；另以最終人物問卷、訊息 descriptor、三語資源與實際 asset bundle、色票、寫作目標及關係圖重跑 35 項通過。舊 1.20／1.21、六種中文角色類型、自訂值（含前後空白）、UUID、原文與恢復資料的往返保存已覆蓋。檔案格式為 1.22、協作 schema 為 8。此回歸紀錄早於本次 P4 全文補齊；目前三語 Help 保留相同 64 個 topic ID、章節／段落／步驟結構與 related links；本機原生多平台實機及語言審校不由這些自動測試取代。

P4 補齊驗證（2026-11-02）：三語 Help 全文、快速切換載入競態、搜尋／歷史保留、英日窄螢幕 200% 文字縮放、日期／數字／百分比／容量、字型實際 cmap／字重與 bundle，以及啟動／錯誤字型皆已覆蓋。67 項格式／Help／時間軸／切換測試與 26 項日期 bootstrap／OOBE 測試通過。完整回歸初跑為 1,347 通過、4 略過、1 個舊文案斷言失敗（仍期待 `3000`，實際顯示 `3,000`）；更新斷言並加驗輸入欄仍為 `2000` 後，同檔 3 項重跑全數通過，因此 1,348 個非略過案例均有通過紀錄。沒有重跑整套第二次。最終靜態分析 0 error／0 warning、226 info；111 個變更 Dart 檔格式檢查與 `git diff --check` 通過。日期符號只快取註冊狀態，每次初始化回傳新 Future，已驗證不同 widget 工作階段均可完成。原生平台的字形視覺審查與人工語言審校仍待 P5。

## 1. 目標與範圍

Internationalization（i18n）建立文字抽離、語系解析、格式化、資源載入及可適應不同語言的版面；Localization（l10n）提供各語言的翻譯、術語、字型、說明內容與品質驗收。

本次目標是讓三種介面語言可跟隨系統、手動選擇、即時切換並在重啟後保留。第一階段發布涵蓋完整操作流程，不能只翻導覽或設定頁就宣稱支援三語。

| 類型 | 本次處理方式 |
| --- | --- |
| App 介面 | 按鈕、導覽、表單、選單、tooltip、語意標籤、通知、空狀態、錯誤與確認對話框全部抽離 |
| 本地化顯示 | 日期、時間、數字、單位、複數、字型與版面納入驗收 |
| 離線說明 | 三語文章、搜尋關鍵詞、目錄與 F1 入口共用穩定 topic ID |
| 使用者作品 | 正文、名稱、註記、角色設定、使用者詞庫與自訂欄位保留原文 |
| 寫作工具資料 | 詞語、贅詞、姓名庫按內容語言處理，不因切換介面而替換或翻譯 |
| 協定及儲存 | XML／JSON 欄位、enum 儲存值、命令 ID、Help ID、MCP schema、P2P／CRDT 資料維持穩定 |
| 後續擴充 | 簡中、韓文、其他語言；完整 RTL 發布、額外地區格式與作品語言設定另立範圍 |

## 2. 現況盤點

以下是建立規劃時的基準，包含當時未提交的既有修改；語系入口、App delegate 與字型等現況已由上述 P1 實作取代，其餘列項仍是後續遷移依據。

| 現況 | 證據與影響 |
| --- | --- |
| 已有基礎相依 | [pubspec.yaml](../dart_edition/pubspec.yaml) 已有 `flutter_localizations`、`intl`；尚無 ARB、`l10n.yaml` 或 App 專用 generated localization |
| 元件語系與 App 文字脫節 | [main.dart](../dart_edition/lib/main.dart) 宣告 en／zh／zh_TW／ja／ko，接上 Material、Cupertino、Widgets、Quill delegate，但沒有 App delegate 或語言偏好 |
| 啟動有多個 App 分支 | `main.dart` 的 splash、初始化失敗、正常畫面各自建立 `MaterialApp`；都要共用 localization 設定 |
| 語言切換尚未實作 | [OOBE](../dart_edition/lib/features/oobe/oobe_screen.dart) 只有停用的繁中選項；[設定頁](../dart_edition/lib/modules/settingview.dart) 仍是語言 placeholder |
| 導覽文字存在常數中 | [AppModule](../dart_edition/lib/features/navigation/app_module.dart) 的 label 為固定繁中；需以穩定 ID 在顯示端取得文字 |
| Ribbon 固定繁中 | [appbar.dart](../dart_edition/lib/bin/appbar.dart) 明確傳入 `RibbonLocalizations.traditionalChinese`；[套件](../dart_edition/packages/material_ribbon/lib/src/material_ribbon_base.dart) 只有英文與繁中，且部分繁中欄位沿用英文預設值 |
| Help 固定繁中並有快取 | [HelpCatalog](../dart_edition/lib/features/help/help_catalog.dart) 固定讀取 `zh_TW.json`，共 64 個主題；[HelpModule](../dart_edition/lib/features/help/help_module.dart) 與 [HelpViewer](../dart_edition/lib/features/help/help_viewer.dart) 都保存載入結果 |
| 字型取系統 locale | [ui_library.dart](../dart_edition/lib/bin/ui_library.dart) 直接讀 `PlatformDispatcher.instance.locale`；手動選日文時不一定取得日文字形 |
| 格式化分散 | [baseinfoview.dart](../dart_edition/lib/modules/baseinfoview.dart) 固定日期格式；[儀表板](../dart_edition/lib/presentation/widgets/radial_gauge_dashboard.dart) 使用未明確指定 locale 的 `NumberFormat` |
| 部分介面已是英文 | [welcome_greeting.dart](../dart_edition/lib/utils/welcome_greeting.dart) 組合英文問候，不能只靠搜尋中文字找待抽離文字 |
| 已有語意鍵可沿用 | [滑桿對照表](../dart_edition/SLIDER_I18N_MAPPING.md) 已定義 `courage`、`cowardly` 等穩定值；不需要翻譯儲存鍵 |

初步靜態掃描：排除 `.freezed.dart`／`.g.dart` 後，`lib/` 約 **152 個檔案、4,011 行**含 CJK 與引號且不是獨立註解。這是盤點線索，包含資料、協定與非 UI 字串，**不是翻譯 key 數量**。第一批遷移前需分類、去重，並補查英文、動態訊息、原生 UI 與套件文字。

後續已建立[文案盤點報告](I18N_COPY_INVENTORY.md)與[三語術語草案](I18N_TERMINOLOGY.md)。報告採 AST 分析字串並分列動態訊息、資料契約、內建素材及原生資源；以報告的快照與限制為準，不與上述初步行數直接比較。

## 3. 技術方案

採用 **Flutter `gen-l10n`＋ARB＋既有 Riverpod／SettingsRepository**。沿用現有依賴，讓翻譯透過具型別 getter／method 存取；不新增一套 runtime 字串 key 翻譯器。

繁中是文案來源；key 使用語意化英文 lowerCamelCase，例如 `settingsLanguageTitle`、`projectSaveFailed`、`editorSelectionCharacterCount`。相同意圖的「取消／確認」可共用；不同情境的「開啟／套用」分開，讓英文與日文能依情境翻譯。

### 3.1 建議目錄與生成設定

以下均為待實作的路徑與設定示意：

```text
dart_edition/
  l10n.yaml
  lib/l10n/
    app_zh.arb                 # 完整繁中來源，也提供 zh 語言層 fallback
    app_zh_Hant.arb            # 繁中 script locale；繼承 zh 的共同文案
    app_en.arb
    app_ja.arb
    generated/                # gen-l10n 生成，提交版本控制
    app_locale.dart           # 可選語言、名稱與偏好正規化
    locale_resolution.dart    # 純函式解析與回退策略
    l10n_extensions.dart      # context.l10n
    app_formatters.dart       # 日期／數字顯示格式
    app_fonts.dart            # 離線字型與語系回退順序
    ribbon_localizations.dart # App ARB 到套件 labels 的 adapter
  assets/help/
    zh_TW.json                # 保留現有路徑，由 locale manifest 對應
    en.json
    ja.json
  tool/check_l10n.dart         # 新增：完整度、placeholder 與資源契約檢查
```

```yaml
# l10n.yaml（示意）
arb-dir: lib/l10n
template-arb-file: app_zh.arb
output-dir: lib/l10n/generated
output-localization-file: app_localizations.dart
output-class: AppLocalizations
preferred-supported-locales:
  - zh_Hant
  - en
  - ja
nullable-getter: false
required-resource-attributes: true
untranslated-messages-file: l10n_untranslated.json
```

`pubspec.yaml` 的 `flutter` 區段加入 `generate: true`。直接從本專案 `lib/l10n/generated/` 匯入生成檔；不使用 `package:flutter_gen`，也不加入已無效果的 `synthetic-package` 設定。

本機 Flutter generator 要求有 script／region ARB 時同時存在 language-only ARB，因此保留 `app_zh.arb`。`app_zh_Hant.arb` 可先僅含 `@@locale` 並繼承繁中文案；完整度檢查應計入繼承，不能要求兩份繁中重複翻譯。生成的 locale 列表會包含 `zh` alias；產品的選單與 `MaterialApp.supportedLocales` 由單一可發布清單管理，只公開 `zh_Hant`、`en`、`ja`，並檢查清單均有生成資源。

### 3.2 翻譯格式契約

- 每個來源 key 提供 `@key.description`，描述畫面、語意與長度限制；placeholder 指定型別及範例。
- 使用完整句與具型別 placeholder，避免 `"已儲存" + name` 或拆成無法調整語序的前綴／後綴。
- 數量使用 ICU plural；英文驗證 0／1／2／大數，繁中與日文依語意採 `other` 或明確 `=0` 分支。
- `select` 僅接受穩定語意值；不可傳入已翻譯文字作邏輯判斷。
- `Text.rich` 問候與帶連結文案也須支援各語言的 placeholder 位置；不要把英文的稱呼順序固定在 helper。
- 變數內容，例如檔名、姓名、路徑與稿件，引入顯示時維持原文。翻譯資源中的換行、引號與大括號需實際跑 generator 驗證。

## 4. 語系偏好與切換行為

### 4.1 儲存與狀態

使用單一設備偏好 `app_locale`，值為 `system`、`zh-Hant`、`en`、`ja`。設定畫面顯示「跟隨系統」、`繁體中文`、`English`、`日本語`，語言自稱固定，讓使用者可找回熟悉語言。

沿用 [SettingsRepository](../dart_edition/lib/data/repositories/settings_repository.dart)，依序加入 snapshot、`saveAppLocale`、[AppSettingsStateData](../dart_edition/lib/models/app_state_data.dart)、[SettingsStateNotifier](../dart_edition/lib/presentation/providers/global_state_providers.dart) 與 OOBE preferences。產生 Freezed 檔，不手改生成碼。新增 enum／value object 透過字串儲存，不用 enum index。

語系只有這個來源；不在舊 `SettingsManager` 再建立第二套偏好。若仍有舊呼叫者，僅提供讀取橋接。UI locale 不加入 `.mnproj`、專案快照或協作 operation；作品的內容語言若將來需要，另設計獨立欄位。

### 4.2 解析規則

優先順序：明確偏好 → 系統偏好語言清單依序匹配 → 繁中預設。`zh-TW`／`zh_TW` 等舊表示正規化為 `zh-Hant`；未知儲存值視為 `system`，保留診斷線索。

| 輸入 | 第一階段結果 |
| --- | --- |
| 手動 `en`，系統日文 | 英文；系統後續改變也維持英文 |
| 系統 `ja-JP` | `ja` |
| 系統 `en-US`／`en-GB` | `en`；第一階段採同一英文語系的格式 |
| 系統 `zh-Hant`／`zh-TW`／`zh-HK`／`zh-MO` | `zh-Hant`；第一階段共用台灣繁中文案 |
| 系統 `zh`／`zh-Hans`／`zh-CN`／`zh-SG` | 明確映射至現有繁中版本；產品不宣稱提供簡中 |
| 系統偏好 `[fr-FR, ja-JP]` | `ja`；不能看到第一個不支援就立即回退 |
| 空清單或全不支援 | `zh-Hant` |

用 `Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')` 表達繁中。以純函式實作解析並接入 `localeListResolutionCallback`；`system` 模式的 `MaterialApp.locale` 保持 null，讓 Flutter 接收系統變更。明確偏好則傳入對應 locale。

若非 Widget 的 formatter／Help provider 也需要 resolved locale，必須與 App 使用同一解析函式、同一系統偏好清單，並隨平台語系變更更新，不能各自回退。新增語言時同步維護這份映射與測試。

### 4.3 不重建工作階段的即時切換

- 初始偏好沿用 `appInitializationProvider` 的首次載入；後續切換不可讓 bootstrap 重新進入 loading。
- Splash 與初始化失敗畫面共用 delegate／locale 設定。尚未讀取偏好時先依系統解析；偏好載入後更新。偏好讀取失敗仍能顯示可理解的復原入口。
- 不用 locale 作整個 `MaterialApp`／編輯器的 Key，不重建 ProviderScope、Navigator 或專案 session。
- 文字從 `Localizations`／provider 反應式取得；避免在 `initState`、static 常數或長期 controller 快取已翻譯字串。
- OOBE 的語言選擇立即保存並生效；即使離開或重開 OOBE，偏好仍保留。OOBE 完成狀態獨立保存。
- 保存失敗顯示可重試錯誤並恢復已持久化的偏好；快速連續切換要序列化或採 latest-wins，避免舊寫入覆蓋新選擇。
- 對已開啟的 Help／對話框重新載入文字；含尚未提交輸入的對話框保留 controller、驗證與選取狀態。

## 5. 各層的責任與遷移重點

### 5.1 導覽、Ribbon 與第三方元件

`AppModule` 保留 `AppModuleId`、index、icon、digit；將 `label` 改為顯示端的 `labelFor(l10n)` 或明確 switch。所有導覽樣式、模組切換器與快捷鍵提示共用這個出口，不能用翻譯結果辨識模組。

App 的命令 label、disabled reason、tooltip 與語意文字放入 App ARB。以 adapter 從 ARB 建立 `RibbonLocalizations`，傳給 `MaterialRibbon`；覆蓋所有欄位，包含現有漏譯的 color／font／increase／decrease 與 `{label}` pattern。套件維持獨立，不反向依賴 App。既有套件 pattern 使用 `{label}` token，adapter 對其輸出格式加入契約測試。

`MaterialApp` 接上 App、Material、Cupertino、Widgets、Quill delegate，集中組合，避免重複註冊。逐一核對鎖定版本 Quill 的三語選單、clipboard／context menu 與語意文字；原生檔案選擇器由作業系統控制的文字記錄為平台限制。快捷鍵依平台顯示 Ctrl／⌘，命令 ID 與快捷鍵本身維持穩定。

盤點已確認 Quill **11.6.0** 的 lookup 以 `countryCode` 選取 `zh_TW`，只有 `zh-Hant` 時會落到簡中 `zh`。P1 必須提供 Quill delegate adapter，將 App 的 `zh-Hant` 對應為套件 `zh-TW`，並保留 App 本身的 canonical locale；或另行採用經測試的帶 TW 地區碼方案。該版本繁中與日文資源各缺少 9 個相對英文來源的 key，生成碼使用英文 fallback；需確認實際可到達的圖片／媒體操作並補譯或明確排除，不能以「套件有該語言」直接通過驗收。

### 5.2 Service、錯誤與協作事件

領域層回傳錯誤 code／enum 與參數，例如 `saveFailed(fileName, reasonCode)`，由 presentation 映射成 App 文案；不把 `BuildContext` 或 `AppLocalizations` 注入儲存、協作、Rust 或業務模型。

先處理仍回傳整句中文的 repository／provider／匯入匯出／P2P merge 流程。內部日誌與穩定錯誤碼可維持原有語言，UI 提供本地化摘要及可複製的技術詳情。協作事件傳語意資料，接收端依自己的 UI locale 顯示，避免把發送端翻譯字串存入共享資料。

非同步動作的結果在呈現時使用當前語系；既有通知不需重播，持續顯示的狀態須可重新產生文字。

### 5.3 離線說明與其他資源

- 建立 locale-to-asset manifest；保留 `zh_TW.json` 路徑，新增 en／ja 並列入 assets。
- `HelpCatalog.load` 接受 locale；快取 key 包含 locale／內容版本。切換時更新 HelpModule、HelpController 與 HelpViewer 的載入結果，避免只改 loader 卻仍讀舊 Future。
- 非同步載入採請求版本或 locale 比對，快速切換時不得讓較舊結果覆蓋較新結果。
- `id`、`relatedIds` 與 F1 topic 維持一致；保留目前 topic 和瀏覽歷史。搜尋 query 可保留，結果以新語系重新計算。
- 翻譯 title、category、keywords、sections；三語均檢查重複／缺漏 topic 和無效連結。日文搜尋驗證無空格關鍵詞，不假設所有 query 都以空格分詞。
- 正式資源以 `assets/help/manifest.json`（contentVersion 2）校驗語系、版本、完整 ID 集合；錯誤提供重試，不把缺漏靜默回退成另一語言。三語每篇章節／段落／步驟數的一致性由 `offline_help_localization_test.dart` 驗證。
- 搜尋涵蓋標題、分類、關鍵詞與全文，英文不分大小寫，輸入法的全形 ASCII／空格正規化後照常搜尋；日文不必分詞。
- `didyouknow.json` 是引用內容，先保留原文與來源標示；`name_eastAsia.json`、`fillerwords.json`、內建詞語資料按內容語言選擇。使用者已編輯或匯入的詞庫不因 UI locale 被覆蓋。

### 5.4 日期、數字、字型與版面

- `context.formats`／`AppFormatters` 明確接收有效語系，不讀寫全域 `Intl.defaultLocale`。啟動時載入 intl 隨附日期符號，獨立元件亦能同步初始化；不需網路。
- 日期使用 `yMd`（英文月／日／年、繁中與日文年／月／日），時間維持 24 小時制；日期時間轉為裝置本地時區。介面語言不改變時區。
- 數字、百分比、進度與「字／詞／項」使用 formatter／ARB；既有 grapheme 及 `WordCountMode` 演算法保持獨立，切換日文不改變計數結果。
- 顯示的整數／小數、百分比與二進位容量使用共用 formatter；容量沿用 B／KB／MB 標籤與 1024 進位。可編輯數字欄保持可解析的原值；XML／JSON、manifest、協定、ID 與檔名時間戳不使用本地化字串。
- `AppFonts` 統一主要字型與回退：繁中 NotoSansTC、日文 NotoSansJP、英文 NotoSans；優先目前語系的 CJK 字形，保留 Latin／其他既有回退。啟動、錯誤、明暗 Theme 與 OOBE 背景採同一政策。八個字型資產均隨 App 提供，測試實際 cmap／variable weight 與 asset manifest；作品文字與自訂樣式保持原值。
- 對固定寬度、固定高度、手動換行、`Row` 中未加彈性約束的 label 做盤點；Tooltip／semantics 不可因視覺截斷而遺失完整訊息。
- 驗證繁中、英文、日文與 30–50% 長度膨脹的測試文案，涵蓋手機窄寬、桌面最小視窗及 200% 文字縮放；新增版面採 `EdgeInsetsDirectional` 等方向性 API。
- 原生 App 名稱、iOS bundle localization、macOS 選單、Windows／Linux 資源與安裝程式逐平台盤點；原生系統 UI 的語言可能與 App 手動偏好不同，發布說明需描述實測行為。

### 5.5 預設名稱、匯出與 AI

空白欄位顯示的「未命名」可以翻譯；已寫入作品的名稱是內容，不在切換時重命名。若建立實體需要預設名稱，在建立當下決定一次並正常保存，不能每次 build 寫回模型。

匯出 UI 與錯誤訊息跟隨介面；稿件文字、使用者標題與既有機器檔名規則保持穩定。閱讀用文件的系統標題若要翻譯，匯出工作建立時固定 output locale，避免執行途中切換產生混合語言；相容性用 manifest／穩定 ID 維持。不能全域取代 [export_service.dart](../dart_edition/lib/application/project_export/export_service.dart) 裡的中文字。

Copilot 按鈕與錯誤納入三語；回覆語言、作品語言、模型 prompt 及 MCP schema 分開處理。介面切換不應默默改變稿件生成語言或對外協定。

## 6. 分階段交付

以下是依賴順序與可驗收切片；工期需在 P0 完成 key 與內容量盤點後估算。

| 階段 | 工作與主要檔案 | 完成條件 |
| --- | --- | --- |
| P0：盤點及術語 | 建立文案清冊，分類 UI／內容／協定；盤點 64 篇 Help、第三方與原生文字；訂三語術語表 | 每個模組有範圍、來源、翻譯與驗收負責人，列出暫留原文的明確理由 |
| P1：語系骨架 | ARB／gen-l10n、SettingsRepository／Freezed／providers、三個 MaterialApp 分支、OOBE／設定選單、locale resolver、CI 接線 | 三語小範圍樣板可生成；切換／重啟／系統跟隨可測，且不重設專案或編輯器 |
| P2：共用操作路徑 | 首頁、問候、導覽、Ribbon、檔案操作、搜尋取代、狀態列、共用對話框與匯入匯出 | 開啟→編輯→搜尋→儲存／匯出可走完三語；尚未完成整體翻譯時只作開發預覽 |
| P3：功能模組 | 角色、關係、世界、物品、章節、大綱、時間軸、計畫、詞庫、校稿修訂、儀表、Copilot、P2P、關於 | 全部模組及主要錯誤／空狀態完成；資料與協作不受語系影響 |
| P4：內容與格式 | 三語 Help、快取更新、格式化、字型、第三方／原生清單、匯出呈現 | 64 篇與新增 Help 完整、三語格式正確，所有已知漏譯有歸屬與結論 |
| P5：發布驗收 | 語言審校、長文案／縮放／平台驗收、生成漂移檢查、文件同步 | 符合下節 gate 後，三語選單正式公開 |

P1 起讓新功能直接採 ARB。既有模組按完整功能切片遷移，避免角色頁等大檔案一次全面替換；每批保留原資料行為與現有測試。P3 翻譯與 P4 Help 內容可在共同術語定稿後同步準備。

術語表至少涵蓋 Chapter／Scene／Outline／Worldbuilding／Revision／Snapshot／Backup，區分「保存、備份、快照、復原」；`Monogatari Assistant`、`MonoAshi`、`Mosaic`、`Rhodanthe` 等品牌及功能名稱訂明保留規則。機器翻譯可提供初稿，英文與日文需由熟悉寫作工具語境的人審校。

## 7. 測試、CI 與發布驗收

### 7.1 CI 設計

在既有 [state-policy-guard.yml](../.github/workflows/state-policy-guard.yml) 增加 `dart_edition/l10n.yaml` 與 `dart_edition/assets/help/**` 的 paths；ARB 已由 `lib/**` 涵蓋。流程加入以下待實作步驟：

```sh
# 在 dart_edition/ 執行；示意未來流程
flutter pub get
flutter gen-l10n
dart run tool/check_l10n.dart
dart run build_runner build --delete-conflicting-outputs
git diff --exit-code -- lib/l10n/generated lib/models/app_state_data.freezed.dart
flutter analyze
flutter test
```

沿用現有格式與 state policy 檢查。除了 diff，還需偵測未追蹤的生成檔（`git diff` 看不到新增未追蹤檔案），並確保翻譯報告輸出目錄可用、報告不含未翻譯 key。生成檔提交版本控制，CI 使用與專案相同的 Flutter 版本以避免無關漂移。

`check_l10n.dart` 檢查來源 metadata、各語言有效 key／placeholder 與型別、plural 必要分支、允許的繼承、額外孤兒 key、Help ID／連結，以及產品語系列表與資源一致性。`gen-l10n` 只生成成功不等於翻譯完整；缺少翻譯必須讓 gate 失敗。

硬編碼檢查採既有 baseline＋例外理由，先攔截本次新增的 UI 字串，逐批縮小 baseline。不能把「禁止所有中文字」當規則，也不能將測試稿件、協定鍵或使用者資料誤報為漏譯。

### 7.2 驗收清單

- [ ] Resolver 涵蓋三語地區變體、中文 script、未知值、空清單與多偏好順序；手動偏好不被系統變更覆蓋。
- [ ] 偏好保存、重啟、寫入失敗與快速切換有明確且一致的結果。
- [ ] 在含未儲存正文、IME composing、游標選取、搜尋狀態、undo history 與開啟對話框時切換；無丟字、失焦或 session 重設。
- [ ] 三語的文字、tooltip、semantics、Ribbon、Quill 選單及開啟中的 Help 均正確更新。
- [ ] Help 的 64 個既有主題及新增主題、related links、F1／Shift+F1、搜尋、歷史與快速切換載入競態通過。
- [ ] 日期／數字使用指定語系；XML／JSON／manifest 輸出與字數結果不因 UI 切換改變。
- [ ] 同一專案在不同語系開啟與保存後，內容／ID／自訂欄位保持等價；若有時間戳更新，使用語意比較而非整檔 byte 比較。
- [ ] 三語環境的 P2P／協作顯示各自本地化，沒有把翻譯文字當合併鍵或共享 enum 值。
- [ ] en／ja 相對繁中來源零缺漏；實際可見 UI 無未核准原文、raw key 或 placeholder。
- [ ] 窄寬／桌面／200% 縮放與長文案無 RenderFlex overflow、遮擋或不可操作的控制項。
- [ ] Windows、macOS、Linux、Android、iOS 等實際發布目標逐一填寫驗收結果；無法執行的平台保留待驗，不能宣稱已通過。
- [ ] 既有以繁中文字定位的測試：互動定位逐步使用穩定 Key／語意 ID；文字驗證保留各語言的明確 assertion，避免完全失去文案檢查。

## 8. 文件與相容性

實作後更新 [GUIDE.md](GUIDE.md) 的 OOBE／語言與支援範圍、[API.md](API.md) 的 Help loader／資源契約，以及內建三語 Help。本文件與 [滑桿對照表](../dart_edition/SLIDER_I18N_MAPPING.md) 的動態 JSON 翻譯示例以本次定案為準；沿用資料鍵，改由具型別映射取得 ARB 文案。

單純新增設備語系偏好與顯示翻譯不需要修改專案格式版本。只有另行改變持久化內容／schema 時才評估 migration；不得為翻譯順便重寫既有專案資料。正式啟用前若任一語言未達 gate，可維持內部預覽，對外支援清單必須反映實際完成範圍。

## 9. 依據與來源

- [Flutter internationalization](https://docs.flutter.dev/ui/internationalization)：ARB、型別化訊息、plural、格式化與平台設定。
- [Flutter generated localization source migration](https://docs.flutter.dev/release/breaking-changes/flutter-generate-i10n-source)：使用專案內生成來源與 `generate: true`。
- [Flutter localeListResolutionCallback](https://api.flutter.dev/flutter/widgets/WidgetsApp/localeListResolutionCallback.html)：完整系統偏好清單與啟動／系統語系變更。
- [Flutter basicLocaleListResolution](https://api.flutter.dev/flutter/widgets/basicLocaleListResolution.html)：預設匹配與 script／region 回退限制。本計畫的中文映射是產品選擇，不是預設演算法保證。
- 本機 Flutter SDK 的 `gen_l10n_types.dart`／`localizations_utils.dart` 已核對 language-only ARB 要求及 `synthetic-package` 的移除提示；正式實作時以專案鎖定 SDK 再執行 generator 驗證。

最初的規劃與盤點未變更 runtime；後續 P1 已新增語系 runtime 與三語入口資源。語系解析、偏好保存、連續寫入／失敗回復、系統變更、OOBE、編輯器與對話框保留均有自動化測試；三語完整翻譯及各平台實機驗收仍待後續階段。既有盤點檔代表其來源雜湊快照，P1 修改後需重新掃描才能取得最新位置。
