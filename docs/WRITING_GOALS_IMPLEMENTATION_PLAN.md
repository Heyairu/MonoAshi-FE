# 每日目標與字數目標作用範圍實作計畫

日期：2026-11-01。狀態：已實作，完成自動化驗證；原生平台實機與長時間運行尚待驗收。第 2 節保留實作前盤點，第 10 節記錄落地結果。

## 1. 需求與範圍

本次新增每日寫作目標、持久化字數目標，並將 `.mnproj` 格式升級至 **1.20**。使用者已確認每日進度採 **所有作品合計的每日淨增字數**；第一版以本機使用者的編輯為統計來源。

| 目標 | 作用範圍 | 保存位置 | 建議初始值 |
| --- | --- | --- | --- |
| 每日目標 | 本機所有作品合計 | App 本機設定 | 1,000 字 |
| 每章目標：預設 | 所有未設定檔案專屬值的作品 | App 本機設定 | 沿用 2,000 字 |
| 全文目標：預設 | 所有未設定檔案專屬值的作品 | App 本機設定 | 沿用 100,000 字 |
| 每章目標：僅限本檔案 | 目前作品的所有章節 | `.mnproj` | 未設定，繼承預設 |
| 全文目標：僅限本檔案 | 目前作品的全文 | `.mnproj` | 未設定，繼承預設 |

「每章」指同一作品各章共用的目標值，不新增個別章節 UUID 覆寫。「全文」對應目前介面的「全書字數」。本次不加入連續達標天數、行事曆、通知、自動排程、跨裝置統計同步或每日目標的檔案覆寫。

每日跨作品合計與每章／全文兩種作用範圍為已確認需求；每日初始值及下述計量細節為實作建議。

## 2. 實作前現況與必要調整

| 現況 | 來源 | 調整方向 |
| --- | --- | --- |
| 格式版本為 1.18 | [ProjectMigrator](../dart_edition/lib/models/project_migrator.dart) | 統一輸出 1.20，保留既有遷移鏈 |
| 每章／全文目標和可見儀表一起存在記憶體，未持久化 | [gauge_dashboard_provider.dart](../dart_edition/lib/presentation/providers/gauge_dashboard_provider.dart) | 分離介面配置、App 預設與檔案覆寫 |
| 目標視窗只有數字，沒有作用範圍 | [radial_gauge_dashboard.dart](../dart_edition/lib/presentation/widgets/radial_gauge_dashboard.dart) | 加入範圍、來源與恢復繼承 |
| 專案沒有目標欄位，且多處手動建立副本 | [ProjectData](../dart_edition/lib/models/project_data.dart) | 所有複製、遷移、收集及載入路徑都須傳遞新資料 |
| 背景重算時，總字數可暫時缺少尚未完成的章節 | [WordCountService](../dart_edition/lib/services/word_count_service.dart) | 每日統計由編輯交易產生，不直接累加總字數 provider 差值 |
| 已有 reader text 投影與背景計數 | [main.dart](../dart_edition/lib/main.dart)、[ContentManager](../dart_edition/lib/bin/content_manager.dart) | 沿用計數演算法，避免把標記語法計入 |

實作完成前，現行格式文件與使用者說明仍描述目前行為；交付時再更新版本與功能保證。

## 3. 預設與僅限本檔案

有效目標依 **檔案覆寫 → App 預設 → 程式內建初始值** 解析。每章與全文各自解析，可只覆寫其中一項。

1. 預設為動態繼承，不在建立作品時複製數字。修改預設會影響所有未覆寫的作品，包含既有作品。
2. 覆寫用 nullable 正整數表示；`null` 表示繼承，不以 `0` 或與預設相等來推測範圍。覆寫剛好等於預設也須保留覆寫狀態。
3. 「恢復使用預設」只清除目前這一種目標的覆寫，不改 App 預設或另一項目標。
4. 修改 App 預設或每日目標只寫本機，不標記作品未保存；寫入失敗保留草稿並可重試，不回報成功。
5. 新增、修改或移除檔案覆寫須標記作品未保存，跟隨一般保存、自動保存及備份；另存新檔沿用覆寫。
6. 沒有可編輯作品時仍可修改 App 預設與每日目標；檔案範圍停用，並尊重協作中繼資料編輯權限。
7. 對話框捕捉 `projectUUID` 與 session generation，套用前再次驗證，避免切檔後寫入錯誤作品。

### 3.1 操作介面

- 沿用儀表「設定字數目標」，提供「預設」及「僅限本檔案」。繼承中預選預設，已有覆寫時預選檔案範圍；兩個範圍各自保留未套用草稿。
- 預設說明為「套用至所有未設定檔案專屬目標的作品」；檔案範圍說明為「隨目前作品保存」，並提供「恢復使用預設」。
- 修改預設不會清除檔案覆寫；目前有覆寫時明示「本檔案仍使用專屬目標 X 字」。資訊選單顯示有效值與「來源：預設／僅限本檔案」。
- 設定頁新增「寫作目標」，編輯每日目標及兩項預設；檔案覆寫由儀表設定，設定頁提供入口提示。
- 統一驗證 `1..999,999,999` 的整數，空白、0、負數及超界顯示欄位錯誤。取消不保存。
- 沿用現有 App 表單、對話框、間距與色彩元件；窄視窗可捲動，支援鍵盤、文字縮放及螢幕閱讀器。

範例：預設每章 2,000；A 覆寫 3,000，B 繼承。預設改為 2,500 後，A 仍是 3,000、B 改為 2,500；A 恢復使用預設後也成為 2,500。

## 4. 所有作品合計的每日進度

### 4.1 計量定義

```text
交易增量 = count(readerTextAfter) - count(readerTextBefore)
當日淨增 = Σ 當日可計入交易增量（跨作品相加）
環形進度 = clamp(max(0, 當日淨增) / 每日目標, 0, 1)
```

保留有號增量，最後才限制環形顯示，不逐交易或逐作品歸零。例如 A +800、B −200 合計 600；先刪 100 再增 150 合計 50。超額顯示實際字數，環形最高 100%；負值顯示「今日淨減 X 字」，環形為 0%。

建議每日統計固定使用既有 `WordCountMode.wordsAndCharacters`（全形字元＋半形單字）；每章／全文仍沿用目前字數模式。切換顯示模式不產生每日增量、不重算歷史。以 `countPolicyVersion` 記錄政策，將來變更另做遷移。

計數前沿用 `InlineAnnotationProjection.readerTextFromRaw` 或既有等效投影，排除 UUID、註記與語法；只改標記且 reader text 相同時增量為 0。背景計數只處理受影響章節，不在輸入事件中掃描整部作品。

### 4.2 操作來源

| 操作 | 每日進度規則 |
| --- | --- |
| 本機輸入、刪字、貼上、插入短語 | 計入淨增減；輸入法只在組字提交後計入 |
| 本機取代、校訂實際改文、手動複製／刪除章節 | 計入整筆操作淨變化，批次只記一次 |
| 本機正文 Undo／Redo | 計入實際反向／正向變化，provider 重播不可再計一次 |
| 改名、移動、切章、目標設定、只改檢視 | 不計入 |
| 開啟、新建初始化、重開、另存、保存、備份 | 不計入；建立當前內容基線，不複製成績 |
| 局部匯入、完整載入、備份復原、外部檔案替換 | 不計入，更新受影響章節基線 |
| 遠端同步、合併、協作他人改文 | 不計入本機個人進度，更新基線 |
| 被排除操作的 Undo／Redo | 同樣排除，不能把匯入的反向操作當成本機產出 |
| 字數模式切換、接受但未改文的校訂標記 | 不計入 |

未保存的本機編輯先反映；保存不再增加。明確放棄未保存變更時，只抵銷該工作階段已計入且被放棄的變化，不把載入舊稿的全部差值算成刪字。混有匯入的歷史還原須保留來源／可計入資訊，正確排除匯入部分。

同 UUID 的另存副本或重新開啟只建立工作階段基線，不複製成績；之後在副本做的本機編輯仍屬新的操作。第一版不掃描磁碟推測過去編輯，也不合併其他裝置的成績。

### 4.3 事件與非同步邊界

由專責 controller 在正文及專案修改邊界接收編輯事件，不以 widget build、選章或 `totalWordsProvider` 當事件來源。

事件至少包含：`eventId`、`sessionGeneration`、`projectUUID`、`chapterUUID`、遞增 revision、`occurredAtUtc`、事件當下本地 `dayKey`／UTC offset、操作來源、可計入旗標及 before／after reader text。正文只存在計數工作期間，不寫入統計檔。

1. 盤點編輯器更新、所有 `updateChapterContent`、章節增刪及歷史套用入口，補來源資訊，避免只接一個輸入 callback。
2. 章節事件按序處理；合併輸入只限同日期、同來源政策及相鄰 revision，取第一個 before 到最後一個 after。
3. 跨來源、跨日、切作品前封存待處理交易；排除的匯入／遠端改文仍更新基線，避免下一次本機編輯把它算進來。
4. 背景結果依原事件歸屬入帳，不能套到目前作品或回傳當日；序號拒絕重複回呼。已封存的合法舊 session 事件仍完成入帳。
5. Undo／Redo 區分新的一次使用者反向操作與同一次 UI 重播；混合來源還原拆出可計入部分，不直接取總差值。
6. 待計數及入帳失敗顯示處理中／重試狀態，不用缺值的暫時計數覆蓋成績。

### 4.4 日期、帳本與保存

- 依裝置當地日曆日期產生 `YYYY-MM-DD`，在下一個當地午夜換日，不以固定 24 小時推算。
- 啟動、回前景、編輯提交及午夜 timer 均檢查日期；午夜不修改作品、不製造字數事件。延遲昨日結果仍入昨日，跨午夜緩衝切開，組字歸提交日期。
- 日期／時區變更只影響新事件，已入帳事件不搬移。
- 按日期及作品 UUID 保存有號小計；合計由小計相加，未開作品也可讀當日總計。
- 目標預設放 SharedPreferences；帳本放 Application Support 的 `Data/WritingProgress.json`，沿用 [palette_repository.dart](../dart_edition/lib/data/repositories/palette_repository.dart) 的目錄慣例。
- 帳本保存 `schemaVersion`、`countPolicyVersion`、日期／作品小計及持久化事件序號。單一寫入佇列將小計與去重序號一起寫暫存檔、flush 後替換，保留最後可讀備份；失敗不可退回直接截斷主檔。
- 可短暫合併寫入；切作品、進背景及正常結束前 flush。異常終止只恢復已落盤統計，最近尚未落盤的變化可能遺失；不以重開稿件差值補算，不宣稱零遺失。
- 損壞時保留原件、嘗試最後可讀備份並提示，不靜默歸零。第一版帳本須由單一 App 寫入者持有；若允許多實例，須加入跨程序鎖與鎖內重讀合併。

### 4.5 每日儀表

新增 `DashboardMetric.dailyWords`，建議排入預設儀表清單第一項，沿用增刪方式。隱藏只改呈現，不停用統計或清除成績。

標題「每日目標」，數值為今天合計／目標。資訊選單顯示日期、「本機所有作品合計」、計量方式與可選的作品小計。修改每日目標只更新分母，不改成績；第一版不新增歷史分析頁。

## 5. 模型與 1.20 格式

| 擬新增模型 | 職責 |
| --- | --- |
| `WritingGoalDefaults` | 本機 `dailyWordGoal`、`chapterWordGoal`、`totalWordGoal` |
| `ProjectWritingGoals` | nullable `chapterWordGoal`、`totalWordGoal`，只存覆寫 |
| `EffectiveWritingGoals` | 衍生有效值及來源，不持久化 |
| `DailyWritingProgress` | 本機日期／作品小計、計數政策及持久化序號 |

`GaugeDashboardSettings` 保留儀表可見性／排列，不再作為目標值唯一來源。舊版只有記憶體目標，重啟後無法復原，不虛構舊持久化資料；首次使用內建 2,000／100,000 與建議每日 1,000。

`ProjectData` 新增預設為空的 `writingGoals`。`empty()`、`collaborationShell()`、全部手動副本、snapshot、遷移、provider 組裝及 coordinator collect／apply 都須保留；不能在保存時把有效預設物化為覆寫。

### 5.1 XML 契約（提案）

```xml
<Project UUID="project-uuid">
  <ver>1.20</ver>
  <!-- 既有 Type 維持原格式 -->
  <Type Version="1">
    <Name>WritingGoals</Name>
    <ChapterWordGoal>3000</ChapterWordGoal>
    <TotalWordGoal>120000</TotalWordGoal>
  </Type>
</Project>
```

- 只寫非 null 覆寫；兩者均為 null 省略整個 Type。只覆寫全文時不輸出每章值。
- App 預設、每日目標與每日帳本不寫入 `.mnproj`，不混入 `BaseInfo/Stats` 或 `PlanSettings`。
- 新增獨立 `WritingGoalsCodec`，使用 XML builder／codec；模組 `Version=1` 與專案 `ver=1.20` 分開管理。
- 缺少區塊／欄位表示繼承；已出現但數值無效、重複或 schema 不支援時給解析／遷移警告。無法可靠解析的區塊以 recovery payload 保留，未經修復不能保存時悄悄丟棄。

### 5.2 舊檔與升級

1. 將 `ProjectMigrator.currentVersion` 改為 `1.20`，沿用 `FileService.projectVersion` 的單一常數來源。
2. 實作前為 1.18，直接升至 1.20，不虛構 1.19 功能；若實作前已有其他工作引入 1.19，先合併其實際契約。
3. 舊檔缺少目標即繼承，不依當下預設補寫；保留 UUID、正文、短語、修訂、章節樹及其他資料。
4. 沿用 `wasMigrated`／重存提示，下次保存輸出 1.20；載入與遷移不產生每日進度。
5. 支援 1.20／1.20.0；1.21／2.0 沿用較新格式的相容性流程。舊 App 可能忽略新增 Type 並在重存時丟失覆寫，需寫入說明。

## 6. 保存、歷史、交換與同步

- **Dirty／歷史**：檔案覆寫實際變更形成一次專案操作，進入 snapshot、dirty 判定與 Undo／Redo；預設及每日帳本不進作品歷史。
- **每日成績與 Undo**：不直接拿舊 snapshot 覆蓋本機帳本，由具來源的正文反向交易調整；只改目標的 Undo 不改成績。
- **完整保存／備份／另存**：保存覆寫；每日帳本獨立本機保存。另存不重複計入已有內容。
- **局部交換**：第一版將目標視為專案中繼資料，不新增勾選模組、不自動夾帶。局部 importer 組裝結果時保留接收作品覆寫，不清空或取代。
- **閱讀輸出**：TXT／Markdown／ZIP 不帶目標與個人帳本；局部 XML 及完整 `.mnproj` 分別測試，避免共用 serializer 意外夾帶。
- **快照同步／三方合併**：覆寫隨作品同步，兩個欄位分別比較 base／local／remote；`null` 是有效的恢復繼承變更，同欄位雙邊修改列明確衝突。
- **即時協作**：兩個 nullable 覆寫納入專案中繼資料 record 的 schema／capability，區分舊 peer 缺欄位與新 peer 清除。同步接線包含 codec、materializer、digest 及相容性檢查；舊 peer 不支援時明示並阻止會丟失目標的路徑。
- **本機邊界**：預設及每日帳本不進協作 record、P2P 摘要或專案 XML。他人增加的字不進本機成績，各裝置預設可不同、檔案明確覆寫應一致。

## 7. 接線位置

新增路徑為建議，沿用現有 Riverpod／repository 分層；表中路徑相對於 `dart_edition/lib/`。

| 位置 | 工作 |
| --- | --- |
| `models/writing_goal_data.dart`（新增） | 預設、覆寫、來源與共同驗證 |
| `models/project_data.dart`、`models/project_migrator.dart` | 欄位、1.20、所有遷移副本 |
| `features/writing_goals/writing_goals_codec.dart`（新增） | XML 與 recovery |
| `data/repositories/writing_goal_preferences_repository.dart`（新增） | 本機目標持久化與注入 |
| `data/repositories/writing_progress_repository.dart`（新增） | 帳本、序列寫入、損壞復原 |
| `features/writing_goals/daily_progress_controller.dart`（新增） | 來源、日期、計數、去重與合計 |
| `presentation/providers/writing_goal_providers.dart`（新增） | 預設載入、專案覆寫、有效值與全域成績 |
| `presentation/providers/gauge_dashboard_provider.dart` | 每日儀表與目標 state 分離 |
| `presentation/widgets/radial_gauge_dashboard.dart`、`modules/settingview.dart` | 儀表、範圍設定與設定頁 |
| `presentation/providers/editor_coordinator_provider.dart`、`main.dart` | collect／apply、來源、組字、session、生命週期 flush |
| `presentation/providers/project_state_providers.dart`、`project_snapshot_utils.dart`、`project_history_provider.dart` | 欄位傳遞與歷史整合 |
| `bin/file.dart`、`application/project_import/`、`application/project_export/` | 完整讀寫及局部交換邊界 |
| `application/collaboration/`、`data/p2p/` 與相關 providers | 同步、合併、能力檢查、遠端事件排除 |

交付時更新 `MNPROJ_FILE_STRUCTURE.md`、`assets/help/zh_TW.json`、`docs/GUIDE.md`、`docs/API.md` 與本計畫狀態。保留 Help topic ID，修正「字數目標重啟需重新確認」的舊說明。

## 8. 分階段實作

| 階段 | 交付 | 完成條件 |
| --- | --- | --- |
| P0：模型與計量契約 | 三種資料分工、修改來源盤點、時間政策 | 解析、來源分類與日期核心測試可執行 |
| P1：持久化與格式 | 設定 repository、1.20、遷移／副本、dirty／history | 舊檔、round trip、保存／備份、Undo、失敗處理正確 |
| P2：每日統計 | 編輯交易、跨作品合計、本機帳本 | 切檔、負值、排除來源、延遲回呼與重啟正確 |
| P3：介面 | 範圍、來源、恢復預設、每日儀表及設定頁 | 所有入口共用有效值，窄版、鍵盤及縮放可用 |
| P4：整合交付 | 交換、同步、協作、說明與回歸 | 覆寫不遺失，個人帳本不外傳，必要回歸通過 |

每日統計接入前先完成來源分類，不使用總字數監聽器作暫時替代。P4 為交付條件，不把同步遺失覆寫當成未註明的後續工作。

## 9. 驗收與測試

1. **作用範圍**：預設改動、獨立繼承、相同數值覆寫、恢復預設、Undo、切檔後舊視窗。
2. **持久化**：重啟、失敗重試、載入完成前不覆蓋已存設定，以及所有專案複製／遷移／備份路徑。
3. **格式**：1.18 → 1.20、1.20.0、1.21／2.0；空值、單項覆寫、損壞／未知區塊及 recovery round trip。
4. **淨增**：A +800／B −200 = 600，A −100／B +150 = 50；切檔、重開、另存不增分。
5. **來源**：輸入、組字、貼上、短語、取代、校訂、章節複製／刪除及 Undo 各算一次；匯入、遠端與其還原排除；放棄草稿只抵銷可計入部分。
6. **文字**：中文、英文、Emoji、組合字元及 reader 投影沿用算法；只改標記或切字數模式不改成績。
7. **非同步／日期**：亂序、重複回呼、跨來源合併、錯誤、切檔、午夜、休眠跨日及時區變更；昨日結果仍入昨日。
8. **帳本**：flush、序列寫入、失敗重試、小計／序號一起提交、損壞恢復、重啟去重，以及異常結束損失界線。
9. **整合**：完整保存保留覆寫、局部匯入保留接收端目標、閱讀／局部輸出不帶個人資料、同步衝突與舊 peer 相容性。
10. **介面**：驗證、取消、範圍草稿、恢復繼承、來源、權限、負值／超額、隱藏仍統計、窄版與文字縮放。

模型／controller 測試注入 clock、計數器與 repository；widget 測試驗證使用者可觀察流程。沿用並擴充 `project_xml_parser_test.dart`、`radial_gauge_dashboard_test.dart`、`project_session_reset_test.dart`、snapshot／history、交換及協作測試，再新增 writing goals／daily progress 測試。實作後執行相關 `flutter test` 與 `flutter analyze`。自動化驗證結果見第 10 節。


## 10. 實作結果與驗證

已完成 `.mnproj` 1.20、App 預設持久化、檔案覆寫與恢復繼承、每日儀表、設定頁、本機帳本、跨日／前景更新、編輯器與章節異動接線，以及檔案、歷史、局部交換及同步整合。

落地細節：

- 有效目標由 Riverpod providers 推導，沒有額外持久化 `EffectiveWritingGoals` 副本。
- 每日 controller 保存章節基線，合併同日期的本機輸入後，在背景計算 reader text 淨變化。匯入／遠端套用受 `isApplyingProjectData` 邊界排除；歷史 entry 另攜帶非持久化的進度座標，以處理混合來源的 Undo／Redo。相同內容的歷史去重仍更新座標。
- 初始未命名工作區也建立基線；保存不重複計入，另存採用新 UUID 時更新後續歸屬。儲存座標綁定寫入快照，即使儲存期間繼續輸入，放棄草稿也只扣回尚未保存的部分。
- 帳本同時使用程序內序列佇列與檔案鎖，合併不同寫入者；小計與序號一起替換，失敗保留工作供重試，原檔損壞時保留證據並讀取備份。
- XML 的無效、未知或重複目標以 `WritingGoalsRecovery` 保存。即時協作 schema 升至 7，BaseInfo record 攜帶明確 nullable 覆寫；三方快照合併分別處理每章／全文及清除。
- 角色協作的既有回歸測試補上切換至可編輯預設資料及捲動定位，讓測試確實從有焦點的編輯欄位切換角色。

新增測試包括 `writing_goals_test.dart`、`daily_writing_progress_test.dart`、`writing_goal_dialog_test.dart` 與 `writing_progress_editor_integration_test.dart`，涵蓋保存／繼承、XML recovery、並行帳本、跨日延遲、失敗重試、儲存中繼續輸入、實際編輯器同步及 Undo／Redo。既有格式、遷移、歷史、局部交換、協作 codec、工作區、儀表及 Help 測試亦納入驗證。

新增功能與測試的 `flutter analyze` 無問題；包含既有主畫面的分析沒有 error 或 warning，仍有原有命名與註解等 info 提示。Help JSON 及 `git diff --check` 亦已檢查。

限制維持第一版範圍：每日進度只合計本機，不做跨裝置個人成績同步；異常終止可能遺失尚未落盤的增量；尚未進行各原生平台的實機、時區切換及長時間效能驗收。
