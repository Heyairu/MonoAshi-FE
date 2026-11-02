# i18n 文案盤點

盤點日期：2026-11-01
範圍：目前工作目錄，包含既有未提交修改。語言目標：繁體中文、英文、日文。

快照說明：本清冊記錄語系基礎導入前的來源雜湊；後續 P1 已修改部分來源及 Help 文字。原始數量與人工決策保留作遷移基準，若要取得目前位置，請依第 8 節重跑並重新複核位置 ID。

## 1. 盤點狀態與產物

已完成首次靜態清冊、重點資料流複核及三語術語草案。每個候選保留來源位置與分類依據；完整清冊仍需依模組逐條複核，尚未核准為 ARB key，後續已於 2026-11-02 將操作介面與各功能模組接入三語 ARB（各 2,343 筆），並加入三語 Help 載入。此清冊保留原始盤點快照，不代表目前行號或漏譯數量。

| 產物 | 用途 |
| --- | --- |
| [Dart 文案候選](i18n/copy_inventory.jsonl) | 一行一筆 JSON；檔案、行列、offset、所屬模組、文字、插值運算式、分類、風險及建議階段 |
| [統計與排除原因](i18n/summary.json) | 全部受掃描 Dart 檔、候選數、排除原因、各模組分類統計 |
| [JSON 內容資源](i18n/asset_inventory.json) | Help 主題清單與所有非空字串的 JSON pointer；另分穩定 ID 與創作內容 |
| [原生介面候選](i18n/native_inventory.json) | 原生選單、權限說明、App 名稱、安裝程式與可能上浮的原生錯誤 |
| [第三方資源檢查](i18n/third_party_inventory.json) | 本機已安裝 Quill 版本、三語 key 覆蓋及回退問題 |
| [人工複核決策](i18n/review_decisions.json) | 已釐清的資料值、共用文案與例外；獨立於自動結果保存 |
| [來源快照](i18n/source_manifest.json) | SHA-256，判斷清冊是否需重新生成 |
| [三語術語草案](I18N_TERMINOLOGY.md) | 共用操作、模組、寫作術語、品牌與待定語意 |

人工決策使用候選位置 ID 指向本次快照；程式移動後 ID 可能改變，重跑時必須確認對應，不將它當成未來 ARB key。

## 2. 數量與分類

<!-- INVENTORY_STATS_START -->
AST 掃描 **298 個 Dart 檔案**（App 295、內嵌 Ribbon 套件 3），共 14,664 個字串節點；留下 **4,759 處候選**，分布於 207 個檔案，正規化文字去重為 **3,609 組**。其中 **752 處含 Dart 插值**；這些數字皆不是已核准翻譯 key 數。

| 自動分類 | 位置數 | 後續動作 |
| --- | ---: | --- |
| 直接顯示候選（`ui`） | 2,046 | 核對語意後抽離 ARB，含英文、tooltip 與語意文字 |
| 間接來源／待複核（`review`） | 1,210 | 追查常數、helper、選項、遷移與資料流 |
| typed error／throw（`error`） | 862 | 確認是否上浮 UI；以錯誤碼與參數映射 |
| 資料值／自然語言鍵（`data_contract`） | 295 | 先查保存與識別語意，不直接翻譯來源值 |
| 匯出路徑文案（`export_content`） | 126 | 區分 UI、輸出標題與檔名策略 |
| 外部整合邊界（`external_contract`） | 86 | 區分模型提示、MCP schema 與使用者訊息 |
| 日誌／assert／debug（`diagnostic`） | 134 | 預設保留；若上浮 UI 另加本地化摘要 |

另有 **179 處**已完成遷移策略複核，保存在人工決策檔；其翻譯與正式 key 仍待核准。
<!-- INVENTORY_STATS_END -->

以上是「出現位置」統計；相同文字去重後仍可能需要多個語意 key。分類基於 AST、參數及來源位置，`ui` 也不等同已核准翻譯。人工決策為額外複核層，不直接改動掃描原始分類，以便追蹤推論依據。

空字串、純符號、只有插值而無固定文案的字串、import、正規表示式、一般機器 token、map／索引鍵會按規則排除。含自然語言的 map／索引鍵則保留為資料契約候選。完整排除理由及數量可在 `summary.json` 查閱。

例如 `description: json['description']` 的 `'description'` 是資料鍵；`Text('Save')` 才是介面候選。不能只依參數名稱或中文字篩選。姓名、稿件等由變數提供的實際內容不會被靜態字串清冊列出，也不應被翻譯。

## 3. 模組與優先順序

<!-- INVENTORY_FILES_START -->
主要來源位置如下；計入所有候選類型，並非各檔案確定需要翻譯的數量。

| 來源 | 候選位置 |
| --- | ---: |
| [lib/modules/characterview.dart](../dart_edition/lib/modules/characterview.dart) | 464 |
| [lib/data/p2p/p2p_project_merge.dart](../dart_edition/lib/data/p2p/p2p_project_merge.dart) | 198 |
| [lib/modules/itemview.dart](../dart_edition/lib/modules/itemview.dart) | 192 |
| [lib/modules/worldsettingsview.dart](../dart_edition/lib/modules/worldsettingsview.dart) | 186 |
| [lib/modules/WelcomeView.dart](../dart_edition/lib/modules/WelcomeView.dart) | 171 |
| [lib/main.dart](../dart_edition/lib/main.dart) | 164 |
| [lib/application/project_export/export_service.dart](../dart_edition/lib/application/project_export/export_service.dart) | 138 |
| [lib/modules/timelineview.dart](../dart_edition/lib/modules/timelineview.dart) | 128 |
| [lib/presentation/providers/p2p_sync_providers.dart](../dart_edition/lib/presentation/providers/p2p_sync_providers.dart) | 122 |
| [lib/modules/proofreadingview.dart](../dart_edition/lib/modules/proofreadingview.dart) | 120 |
| [lib/modules/copliot.dart](../dart_edition/lib/modules/copliot.dart) | 116 |
| [lib/features/oobe/oobe_screen.dart](../dart_edition/lib/features/oobe/oobe_screen.dart) | 112 |
| [lib/modules/settingview.dart](../dart_edition/lib/modules/settingview.dart) | 109 |
| [lib/modules/outlineview.dart](../dart_edition/lib/modules/outlineview.dart) | 100 |
| [lib/modules/character_relationship_graph_view.dart](../dart_edition/lib/modules/character_relationship_graph_view.dart) | 88 |
| [lib/modules/glossaryview.dart](../dart_edition/lib/modules/glossaryview.dart) | 88 |
| [lib/bin/file.dart](../dart_edition/lib/bin/file.dart) | 87 |
| [lib/data/p2p/p2p_endpoint_service.dart](../dart_edition/lib/data/p2p/p2p_endpoint_service.dart) | 85 |
| [lib/bin/appbar.dart](../dart_edition/lib/bin/appbar.dart) | 74 |
| [lib/domain/models/p2p_revision_models.dart](../dart_edition/lib/domain/models/p2p_revision_models.dart) | 64 |
<!-- INVENTORY_FILES_END -->

建議按可驗收操作路徑處理，而非依字串最多的檔案先翻譯：

| 批次 | 內容 | 重點 | 責任角色 |
| --- | --- | --- | --- |
| A／P1 | 語言入口、OOBE、設定、啟動與初始化失敗 | 避免先進入看不懂的引導；確認三語 delegate 與字型 | App 設定與啟動維護者 |
| B／P2 | 共用對話框、導覽、Ribbon、首頁、檔案、搜尋、狀態列、匯入匯出操作 | 處理預設參數、命令 labels、動態數字和錯誤摘要 | UI library、導覽與專案 I/O 維護者 |
| C／P3 | 角色、物品、世界、大綱、章節、時間軸、關係、計畫、校正、修訂、儀表與寫作目標 | 顯示文字與作品資料值拆開，保留 draft／controller | 各功能維護者 |
| D／P3 | P2P、協作、Copilot、MCP 與 service 回傳訊息 | 釐清使用者可見訊息、診斷及外部契約 | 協作與整合介面維護者 |
| E／P4 | Help、格式化、字型、原生選單、安裝程式與發行資訊 | 核對有效功能覆蓋，不把素材當 UI 全部翻譯 | 內容與平台發布維護者 |

上述為責任角色建議，尚未指派具名負責人。每批英文／日文翻譯與語言審校也需指定負責人；不能將首次掃描視為 P0 全部完成。

## 4. 已人工複核的關鍵項目

### 4.1 中文已是資料值：角色類型

[character_data.dart](../dart_edition/lib/models/character_data.dart) 的 `defaultCharacterType`／`characterTypeOptions` 有六種中文值。`CharacterEntryData` 讀寫 `characterType`；[characterview.dart](../dart_edition/lib/modules/characterview.dart) 的 RadioListTile 使用相同的 `type` 作 `title` 和 `value`，並寫入 XML `CharacterType`。

處理方式：保留既有 value 與讀寫相容性，顯示端透過明確映射取得翻譯。不可把選項 list 換成翻譯後字串，否則選取、既有資料辨識及保存結果會改變。1.22 已依使用者要求建立英文 ID 遷移，對照表與相容性見 `dart_edition/MNPROJ_FILE_STRUCTURE.md`。

同樣需要審視 `timeline_data.dart` 的 `originLabel = 故事開始`、自動建立的名稱、遷移產生的說明與使用者可修改的內建選項；不能因其出現在 model 就直接全部保留或全部翻譯。

### 4.2 中文參與衝突 identity

[p2p_project_merge.dart](../dart_edition/lib/data/p2p/p2p_project_merge.dart) 將「作品資訊」等值用作 `fieldPrefix`。[P2pFieldConflictItem](../dart_edition/lib/domain/models/p2p_sync_models.dart) 將 `fieldPathSegments` 編碼進 `conflictId`。

處理方式：維持 conflict ID 與欄位路徑的原有語意值，在衝突畫面另做顯示映射；不可在 merge service 直接套 UI locale，造成同一衝突在不同語系有不同 ID。此項比一般 label 替換優先。

### 4.3 model 回傳的驗證文案

[writing_goal_data.dart](../dart_edition/lib/models/writing_goal_data.dart) 的 `validateWritingGoal` 回傳「請輸入 1 到 999,999,999 的整數」，[writing_goal_dialog.dart](../dart_edition/lib/presentation/widgets/writing_goal_dialog.dart) 直接傳入表單 validator。

處理方式：有效性檢查維持純邏輯，UI 映射驗證結果；建議 `writingGoalInvalidRange(min, max)`，兩個界限由數值 formatter 處理。不能只抽離設定頁文字而漏掉這個訊息，也不要為了翻譯把 AppLocalizations 放進 model。

### 4.4 預設參數與靜態常數

[dialogs.dart](../dart_edition/lib/ui_library/dialogs.dart) 的 cancel／confirm／close、[collections.dart](../dart_edition/lib/ui_library/collections.dart) 的 tooltip／emptyTitle、[tables.dart](../dart_edition/lib/ui_library/tables.dart) 的空狀態等，使用中文預設參數。

處理方式：保留呼叫者可覆寫的參數，預設改由當次 build／dialog 的 context 解析，不能讓 getter 或共用 controller 快取上一語系。導覽常數與滑桿 `uiTitle`／`uiLeft`／`uiRight` 同理；`xmlTitle`／`xmlLeft`／`xmlRight` 保留。

### 4.5 動態訊息與稱呼

- 狀態列 `currentWords / totalWords 字`：保留兩個數值參數與計數模式，不把兩種模式一律翻成 words。
- OOBE「步驟 index，step」與「每 interval 分鐘」：以完整句及數量規則處理，步驟名稱本身也要本地化。
- 設定頁容量 `bytes / maxSize MB ・ fileCount 份`：格式化數值與份數，不保存顯示字串。
- 問候 helper 的 Morning／Afternoon／Evening／Night／User 與 `Good period` 是英文，也在清冊內；應改為依時段選擇完整訊息，不把既有英文 prefix／suffix 套給日文。
- 原始插值會以 `{p1}`、`{p2}` 表示，`placeholders` 保存原運算式。這是盤點記號，正式 ARB 必須改成有語意名稱及型別的參數。

### 4.6 匯出文案與檔名

[export_service.dart](../dart_edition/lib/application/project_export/export_service.dart) 同時有閱讀文件欄名、布林顯示、未解析參照與 `safeExportName` 的「未命名」檔名回退。部分中文 map key 是傳給 `values()` 的閱讀用輸出標題，經複核可列為匯出文案，而非持久化 schema。

處理方式：逐個輸出路徑確認。閱讀標題可使用固定於工作建立時的 output locale；檔名安全規則、完整專案 XML、穩定 ID 與使用者命名保持相容。不能對此檔進行全域中文字替換。

## 5. 共用文案候選

以下僅在語意相同時共用；完整草案見[術語表](I18N_TERMINOLOGY.md)。數量只計自動分類為 `ui` 的原文位置，不包括錯誤、素材及間接來源。

<!-- INVENTORY_COMMON_START -->
| 原文 | UI 候選位置 | 建議 key |
| --- | ---: | --- |
| 取消 | 49 | `commonCancel` |
| 確定 | 3 | `commonConfirm` |
| 完成 | 1 | `commonDone` |
| 關閉 | 6 | `commonClose` |
| 儲存 | 10 | `commonSave` |
| 建立 | 3 | `commonCreate` |
| 新增 | 6 | `commonAdd` |
| 刪除 | 8 | `commonDelete` |
| 重試 | 5 | `commonRetry` |
| 複製 | 5 | `commonCopy` |
| 重新命名 | 2 | `commonRename` |
| 未命名 | 1 | `commonUntitled` |
| （未命名） | 6 | `commonUntitledParenthesized` |
| 復原 | 2 | `editorUndo` |
| 重做 | 2 | `editorRedo` |
<!-- INVENTORY_COMMON_END -->

「複製」若指剪貼簿用 Copy，若指建立副本則用 Duplicate，需分 key；「復原」用於 Undo，「從備份還原」則是 Restore。不得以中文相同作自動合併依據。

## 6. 內容資源與原生介面

<!-- INVENTORY_ASSETS_START -->
| JSON 資源 | 非空字串位置 | 穩定 ID 候選 | 內容候選 |
| --- | ---: | ---: | ---: |
| [assets/help/zh_TW.json](../dart_edition/assets/help/zh_TW.json) | 1,468 | 286 | 1,182 |
| [assets/jsons/didyouknow.json](../dart_edition/assets/jsons/didyouknow.json) | 114 | 0 | 114 |
| [assets/jsons/fillerwords.json](../dart_edition/assets/jsons/fillerwords.json) | 16 | 0 | 16 |
| [assets/jsons/glossary.json](../dart_edition/assets/jsons/glossary.json) | 68 | 21 | 47 |
| [assets/jsons/name_eastAsia.json](../dart_edition/assets/jsons/name_eastAsia.json) | 1,128 | 0 | 1,128 |
| [assets/jsons/palettes.json](../dart_edition/assets/jsons/palettes.json) | 0 | 0 | 0 |

Help 的內容候選共 **1,178** 處，包含分類、關鍵詞、段落等重複位置；不是 1,178 篇文章或 UI key。
<!-- INVENTORY_ASSETS_END -->

Help 現有 64 個主題。title、category、keywords、heading、paragraphs、steps 是翻譯範圍；`id`／`relatedIds` 保留，搜尋索引、F1 topic 與快取需按語系更新。英文與日文尚無對應 Help 檔。

`didyouknow.json` 是 57 組引句／來源；先保留原文與出處。姓名庫有 1,128 個非空字串，包含日／中／韓素材；既有姓名資料不因切換介面而翻譯。詞語庫包含資料 ID 與使用者可編輯文字；贅詞是內容分析素材。這些數字不能加進 UI 翻譯 key 的工時估算。

原生清冊掃描 33 個檔案，列出 181 個待複核位置，其中包含診斷與品牌，並非 181 個確定翻譯 key：

| 平台／來源 | 已確認問題 | 後續處理 |
| --- | --- | --- |
| iOS／macOS `Info.plist` | 本地網路權限用途說明只有繁中；文件型別名稱／App 名稱需對齊 | 繁中／英／日的原生 localization 資源，保留 bundle 與 UTI 識別值 |
| macOS `Base.lproj/MainMenu.xib` | 65 個 title 位置，包括原生選單、子選單與視窗；有英文及 APP_NAME | 查實際選單可達性，為有效操作提供三語原生文案 |
| Android manifest／MainActivity | App label 固定繁中；原生錯誤包含英文句子 | App 名稱按平台資源處理；錯誤 code 在 Dart 顯示層映射 |
| Windows `Runner.rc` | FileDescription／ProductName 仍為 `dart_edition`，公司與版權也有樣板值 | 發布資料與品牌決策，不能僅視為翻譯問題 |
| Linux runner／desktop／MIME | runner 名稱 MonoAshi、desktop 名稱 Monogatari Assistant；描述為英文 | 確認品牌與本地化描述，機器 class／MIME 保留 |
| Web manifest／index | `dart_edition` 與 `A new Flutter project.` 樣板文字 | 列為 Web 發布前必修，另確認是否屬實際發布目標 |
| `nsExec/Installer.nsi` | MUI 提供繁中與英文，尚無日文；自訂 MessageBox 仍固定繁中；Install／Uninstall 未本地化 | 自訂文案採 LangString，新增日文；安裝器版本目前為舊 Beta，需由發布維護者確認使用狀態 |

原生 label 與系統權限對話框未必能跟隨 App 內手動選擇；需區分作業系統語言與應用程式語言並實機驗收。

## 7. 第三方整合發現

依 `.dart_tool/package_config.json` 定位本機 Quill **11.6.0**，檢查 ARB 與生成來源，未修改套件快取。

1. `quill_localizations.dart` 先按 countryCode 分流 TW／HK／CN；沒有 countryCode 的 `zh-Hant` 落入 `FlutterQuillLocalizationsZh`，該類別是簡中。因此 App 繁中 locale 需要 Quill adapter 映射到 `zh-TW`。
2. 英文來源有 106 個 key；繁中與日文 ARB 各 97 個，相對缺少 9 個媒體相關 key。生成的中文／日文 getter 會顯示英文。
3. 缺漏是 `insertVideo`、`errorUnexpectedSavingImage`、`successImageSavedGallery`、`successImageSaved`、`successImageDownloaded`、`openGallery`、`openFileLocation`、`openFile`、`saveImagePermissionDenied`。先核對本 App 是否能進入這些功能，再補 App override／套件修正或記錄不可達；不需為未使用功能擴大 runtime 範圍。
4. Ribbon 有獨立英文預設與繁中物件，沒有日文；繁中未覆寫 color、font、increase、decrease 等欄位。App adapter 需填滿全部欄位，並保留 `{label}` pattern 契約。

以上是來源核對結果；App 的 delegate adapter、選單可達性與切換行為仍需功能測試。

## 8. 重跑、驗證與限制

在 `dart_edition/` 使用已安裝且符合專案版本的 Dart 與既有 `.dart_tool/package_config.json`：

```sh
dart --packages=.dart_tool/package_config.json tool/inventory_l10n.dart --self-test
dart --packages=.dart_tool/package_config.json tool/inventory_l10n.dart
python3 tool/inventory_l10n_resources.py
dart analyze tool/inventory_l10n.dart
```

直接執行 script 使用現有 analyzer 鎖定版本，避免 `dart run` 啟動無關的 App native build hooks；若尚未安裝相依，先完成專案的一般依賴設定。工具不新增相依、不修改 runtime，也不是未來的翻譯完整度 CI gate。

已驗證 scanner 的註解／import 排除、單字英文、動態插值、相鄰字串合併、插值內分支、資料 map key、包裝呼叫中的欄位鍵、JSON 索引鍵、診斷及 typed error 分類；Dart 靜態分析通過。JSON 資料、來源位置、參數數量、重複候選 ID、快照及文件連結另做一致性檢查。沒有執行 App UI、原生平台或翻譯功能驗收。

限制：

- 所有自動分類都可能有誤報或漏報；短英文若只透過未知 helper／model 變數傳遞，可能未被辨識。例外要以資料流複核，不憑分類批次改碼。
- 以 unresolved AST 判斷語境，沒有跨函式資料流或使用者可見性證明；`error` 包含可能只進日誌的訊息，`external_contract` 包含需再區分的 Copilot／MCP 文案。
- JSON pointer 提供資源定位；原生掃描採欄位與字串規則，可能包含 build error、日誌、品牌及重複 title。
- 不掃生成 Dart、測試資料、tool 本身、Rust、任意第三方套件、動態伺服器回覆；Quill 另以已安裝資源專項檢查。圖像／影片嵌字與遠端內容需要另外人工確認。
- 本次數量只代表所附來源快照；後續程式改動需重跑並複核人工決策。清冊與術語草案不等於翻譯完成或全平台已支援。

下一步可從批次 A、B 建立人工確認的 ARB key 清單；角色型別、衝突 identity 與匯出檔名這些資料邊界，先依本次決策設計映射後再遷移。

## 9. P4 補齊紀錄（2026-11-02）

三語離線 Help 已由英日摘要補為全文，各 64 篇、167 章節、258 段內文與 230 個步驟，並保留相同 ID／related links。manifest 版本 2、完整性檢查、語系快取、載入競態與搜尋正規化已實作。`AppFormatters` 統一日期、24 小時本地時間、數字、百分比與容量的顯示；`AppFonts` 統一工作區、啟動／錯誤與 OOBE 字型及依語系排序的混合字體回退。機器格式、計數規則與稿件原文不變。此項完成不代表上述原生安裝器／選單／平台資源或人工語言審校已驗收。
