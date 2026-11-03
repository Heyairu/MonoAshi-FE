# Monogatari Assistant 文件中心

更新日期：2026-11-01

適用範圍：本儲存庫的 Flutter 應用程式與隨附整合介面

| 文件 | 讀者 | 內容 |
| --- | --- | --- |
| [統一說明文件](GUIDE.md) | 使用者、開發者 | 功能、操作、專案資料、環境設定、架構、建置與維護 |
| [統一 API 文件](API.md) | 開發者、整合者 | MCP、檔案 API、Rhodanthe、Copilot adapter、P2P 與協作契約 |
| [參考文件索引](SOURCES.md) | 維護者 | 保留的專題規格、使用指南、設計與發布驗收文件 |
| [專案首頁](../README.md) | 所有讀者 | 專案介紹、畫面預覽與快速啟動 |
| [宣傳網站原始檔](index.html) | 所有讀者 | M3 Teal 產品介紹頁；[GitHub Pages 發佈與維護](WEBSITE.md) |

## 文件使用原則

說明文件與 API 文件是日常查閱入口；細部規格由仍保留的專題文件承接。已被統一文件取代的舊指南、重複報告與完成階段紀錄已移除，歷史內容可由 Git 查閱。`MNPROJ_FILE_STRUCTURE.md` 同時是 App 的內建 asset，維持原路徑。

主文件以目前程式碼為依據。文件中的「已實作」表示可以在原始碼找到對應行為，不代表所有平台都已通過發布驗收。保留的發布紀錄中，測試數量、效能數值與 artifact hash 只適用於記錄當時的版本。

i18n 與 Localization 見[三語實作規劃](I18N_LOCALIZATION_PLAN.md)。語系解析、系統跟隨、即時切換與本機偏好已實作；繁體中文、英文、日文的完整介面與離線說明翻譯仍分階段進行。

第一批[文案盤點](I18N_COPY_INVENTORY.md)已提供來源清冊、資料邊界與優先順序；[三語術語草案](I18N_TERMINOLOGY.md)供後續翻譯審校使用，尚未套用於 App。

## 統一撰寫規範

- 使用繁體中文說明；程式識別字、協定欄位、檔案名稱維持原文。
- 一份文件使用一個一級標題，依序安排範圍、操作或介面、限制、驗證與來源。
- API 按介面列出用途、參數與預設值、回傳值、錯誤、版本及可執行或明確標示的示意範例。
- 區分對外 MCP、App 內部 HTTP bridge、Dart 呼叫介面與原生 C ABI；不要把它們混寫成 REST endpoint。
- 相對連結從文件所在目錄出發；程式來源連到實際檔案，避免只寫路徑而無法導覽。
- 新功能先更新說明文件與 API 文件；必要的設計與驗收資料另存專題文件，並更新參考文件索引。完成實作後合併重複內容，避免累積同主題的階段報告。
- 版本、限制和預設值以程式常數與 `pubspec.yaml` 為準；發布狀態以對應平台的最新驗收證據為準。

## 內容核對入口

| 項目 | 來源 |
| --- | --- |
| App 版本與 Dart SDK | [pubspec.yaml](../dart_edition/pubspec.yaml) |
| 專案 XML 版本 | [ProjectMigrator](../dart_edition/lib/models/project_migrator.dart) |
| MCP 工具與輸入 schema | [MCP server](../dart_edition/lib/features/mcp/application/monoashi_mcp_server.dart) |
| MCP 回傳值與預設值 | [MCP adapter](../dart_edition/lib/features/mcp/application/monoashi_mcp_adapter.dart) |
| 讀取容量限制 | [ProjectReadBudget](../dart_edition/lib/features/story_read/domain/project_read_models.dart) |
| 原生文字分析協定 | [Rhodanthe protocol](../dart_edition/lib/infrastructure/rhodanthe/rhodanthe_protocol.dart) |
| 即時協作版本 | [CollaborationSchema](../dart_edition/lib/domain/collaboration/collaboration_operation.dart) |


## App 內建說明

- 操作入口：[F1 與離線說明](GUIDE.md#離線說明與-f1)。
- 模組與快捷鍵：[模組切換與鍵盤導覽](GUIDE.md#模組切換與鍵盤導覽)、[日常操作快捷鍵](GUIDE.md#日常操作快捷鍵)。
- 開發介面與內容維護：[Help API](API.md#9-app-內-help-介面)。
- 隨 App 發布的內容：[zh_TW.json](../dart_edition/assets/help/zh_TW.json)。

說明中心內容更新於 2026-11-01，包含 64 個繁體中文主題，可離線搜尋。從工具列「說明」開啟，或按 F1 查看目前功能；Shift+F1 可點選控制項求助。窄視窗透過「目錄與搜尋」及「閱讀文章」切換。

| 閱讀目的 | 說明中心主題 |
| --- | --- |
| 第一次建立作品 | 快速開始與說明首頁、首次啟動與名稱設定、章節選擇、正文編輯 |
| 保存與找回稿件 | 儲存檔案、另存新檔、保存／備份／復原、自動儲存與備份設定 |
| 整理故事設定 | 大綱、時間軸、角色、關係、世界、物品、Scene 快照與狀態變化 |
| 提升寫作效率 | 正文標記與註記、專案短語庫、輸入／縮排／智慧候選、詞語參考與文字色票 |
| 查看進度與調整儀表 | 儀表板與寫作進度：六種儀表、每日目標與字數目標作用範圍、新增／移除、校訂雙環與明細側欄 |
| 校稿與交付 | 搜尋與取代、文本校正與修訂、修訂追蹤與比較基準、局部匯入／匯出 |
| 連接外部工具或裝置 | Copilot、MCP 唯讀整合、內網同步與協作排解 |
| 排查操作問題 | 常見問題、鍵盤快捷鍵、工具列模式、操作對話框 |

每個主題依需要提供用途、操作步驟、範例、限制與相關說明。內容以目前程式碼為準，尤其區分自動儲存與備份、Scene 狀態快照與檔案復原、修訂接受與拒絕，以及閱讀用匯出與完整專案保存。

維護時直接更新上述 JSON，讓 App 的離線內容與搜尋共用同一份來源。保留既有主題 ID；新增延伸閱讀可從分類目錄及 `relatedIds` 連入，需要 F1 定位的控制項則另接 Help topic／scope。內容修改後執行 `flutter test test/help_test.dart test/help_editor_integration_test.dart`，驗證資源載入、連結、搜尋及閱讀介面。
