# 快捷鍵實作規劃

規劃日期：2026-11-01。依目前工作目錄的程式碼（包含尚未提交的變更）盤點；本文是待實作提案，表中的建議配置不代表已提供。

實作進度（2026-11-01）：已接入 18 個模組目錄、固定模組切換按鈕、可搜尋切換器、Alt＋四方向導覽、數字直接跳轉、設定別名與嵌入式說明模組；並補另存、搜尋聚焦、取代展開、結果導覽及 Ctrl+Y。使用方式以 [統一說明文件](GUIDE.md#模組切換與鍵盤導覽) 與 App 內「鍵盤快捷鍵」為準。下列架構及 P2／P3 仍作後續規劃；未新增通用命令清單或使用者自訂快捷鍵設定。測試結果與平台限制見本文驗證段落。

## 1. 範圍與現況

第一輪以 Windows、macOS、Linux 桌面工作區為主；行動版外接鍵盤沿用可用命令，另行驗收。Web 需另處理瀏覽器保留按鍵，不直接套用桌面發布結論。快捷鍵只在應用程式取得焦點時生效。

| 區域 | 目前實作 | 待處理事項 |
| --- | --- | --- |
| 主畫面 | `main.dart` 使用 `Shortcuts`／`Actions` 註冊 N、O、S、F、Z、Shift+Z；Apple 原生平台使用 Command | 命令與平台判斷集中管理，避免直接分散呼叫不同 handler |
| 搜尋 | `FindIntent` 呼叫 `_toggleFindReplaceWindow()` | 改成開啟／聚焦；補取代展開、搜尋欄焦點與鍵盤結果導覽 |
| 正文 | `content.dart` 與 Quill 各自處理剪貼簿、復原、Tab、Ins 及候選操作 | 保留 Mention 原子邊界、純文字與投影契約，統一可設定的綁定來源 |
| 重做 | 主畫面及 CodeField 路徑有 Shift+Z；Quill 額外支援 Windows／Linux 的 Ctrl+Y | Ctrl+Y 成為非 Apple 平台共同別名 |
| 說明 | `HelpController` 的 early key handler 處理 F1、Shift+F1、Esc 與點選求助期間的輸入阻擋 | 保留現有保護機制；整合命令目錄與顯示資訊，避免重複註冊事件 |
| Ribbon | 套件內處理 Ctrl+F1、Alt／F10、頁籤方向鍵等；作用域限 Ribbon | 宿主協調全工作區入口；不直接依賴套件 registry 派送業務命令 |
| 檔案 | `_handleFileAction` 現為 `Future<void>`，會等待各檔案 handler；工具列另有 `_running` 及 I/O busy 檢查 | 將跨入口的互斥、完成狀態與錯誤處理提升至共用執行邊界 |
| 設定與提示 | 快捷鍵說明為靜態 JSON；Ribbon 命令未提供 shortcut 字串 | 同一綁定資料產生 tooltip、模組清單與快捷鍵說明 |
| 模組導覽 | `slidebar.dart` 有 16 個目的地，包含首頁、設定、關於；正文另用特殊頁面索引，說明中心使用對話框 | 建立統一模組目錄，加入正文與說明，提供切換按鈕及快捷鍵；以穩定 ID 轉接現有索引 |

本計畫延續 [Ribbon 導入計畫](MATERIAL_RIBBON_ADOPTION_PLAN.md) 的共用 dispatcher 方向；以目前程式為準，例如檔案 handler 已非該文件早期描述的 `void`。

## 2. 建議按鍵與操作契約

下表 `Mod` 在 Windows／Linux 為 Ctrl，在 macOS 為 ⌘。P1 是第一批功能，P2 是進階工作流，P3 是使用者自訂。已有功能也要完成整合與回歸，才算該階段交付。

依使用者指定，主要導覽採 **Alt＋方向鍵：左右切換 Ribbon 頁籤，上下切換模組**。macOS 對應 Option（⌥），不改成 Command；四個方向在不同焦點區域維持相同意義，詳見 2.6。

### 2.1 專案與設定

| 命令 ID（擬新增） | 功能 | Windows／Linux | macOS | 實作與可用條件 | 階段 |
| --- | --- | --- | --- | --- | --- |
| `project.new` | 新建專案 | Ctrl+N | ⌘N | 沿用 `_newProject()` 與未儲存確認；不在資料欄位內解讀成新增角色或章節 | P1，已有 |
| `project.open` | 開啟專案 | Ctrl+O | ⌘O | 沿用 `_openProject()`，等待選檔、確認與載入完成 | P1，已有 |
| `project.save` | 儲存 | Ctrl+S | ⌘S | 沿用 `_saveProject()`；沒有位置時走既有另存流程 | P1，已有 |
| `project.saveAs` | 另存新檔 | Ctrl+Shift+S | ⌘⇧S | 沿用 `_saveProjectAs()`；取消不改原位置與 dirty 狀態 | P1，新增綁定 |
| `project.import` | 局部匯入 | Ctrl+Shift+I | ⌘⇧I | 開啟既有匯入流程；仍需選檔、選擇項目與確認 | P2，新增綁定 |
| `project.export` | 匯出 | Ctrl+Shift+E | ⌘⇧E | 開啟既有匯出對話框，讓使用者選內容與格式 | P2，新增綁定 |
| `module.open.settings` | 設定模組 | Ctrl+,；Ctrl+8 | ⌘,；⌘8 | 與模組切換按鈕共用設定模組入口，先同步正文；有 modal 時不切頁 | P1，新增綁定 |

退出沿用系統與 `_requestExit()` 的既有保護流程。首輪不額外攔截 Alt+F4／⌘Q，也不新增尚無完整工作流的「關閉專案」。

### 2.2 編輯與搜尋

| 命令 ID（擬新增） | 功能 | 建議按鍵 | 實作與可用條件 | 階段 |
| --- | --- | --- | --- | --- |
| `edit.selectAll` | 全選 | Mod+A | 一般欄位交由原生編輯行為；正文交由既有 adapter；不全選其他頁面或隱藏章節 | P1，整合 |
| `edit.cut`／`edit.copy`／`edit.paste` | 剪下／複製／貼上 | Mod+X／C／V | 以目前輸入框為目標，正文保留 raw／display 映射、Mention 與純文字剪貼簿規則 | P1，已有 |
| `edit.undo` | 復原 | Mod+Z | 正文沿用 project history；一般欄位保留自身 undo；非輸入區才依頁面能力選用 project history | P1，已有 |
| `edit.redo` | 重做 | Mod+Shift+Z；Windows／Linux 加 Ctrl+Y | 與復原使用相同目標與歷史來源，兩編輯器一致 | P1，補齊別名 |
| `search.open` | 開啟／聚焦搜尋 | Mod+F | 已開啟時只聚焦並選取搜尋文字；不關閉搜尋列，不無條件把其他欄位的選字當搜尋詞 | P1，調整行為 |
| `search.replace.open` | 展開／聚焦取代 | Windows／Linux：Ctrl+H；macOS：⌘⌥F | 開啟搜尋、展開取代並聚焦取代框；macOS 不使用會隱藏 App 的 ⌘H | P1，新增 |
| `search.next`／`search.previous` | 下一個／上一個結果 | Windows／Linux：F3／Shift+F3；macOS：⌘G／⌘⇧G | 僅正文搜尋情境；等待目前查詢的有效結果，保留 latest-wins 與結果上限 | P1，新增 |
| `search.next`／`search.previous` | 搜尋框內導覽 | Enter／Shift+Enter | 僅搜尋框且未組字；搜尋列不因跳轉立即失焦；正文內仍是換行 | P1，新增 |
| `search.replaceOne` | 取代目前結果 | 搜尋／取代區內 Mod+Enter | 組字完成且目前結果仍有效才執行；沿用既有單次取代交易 | P2，新增 |
| `search.replaceAll` | 全部取代 | 預設不綁定 | 由既有按鈕進入，沿用既有大量取代處理；P3 可自行配置 | P2，命令整合 |
| `search.close` | 關閉搜尋 | Esc | 只在沒有更上層候選／popup／modal／KeyTip 消費 Esc 時關閉，回到原正文選區 | P1，新增 |

一般欄位的 Undo／Redo 不得因無法復原而落到整份作品的歷史。已識別到輸入目標時，是否可以執行及是否繼續傳遞事件須分開判斷，避免停用動作意外觸發祖先命令。貼上及取代等非同步寫入需重新驗證專案 session、章節、目標是否存活與內容版本。

### 2.3 正文、候選與創作工具

| 功能 | 建議按鍵／入口 | 實作契約 | 階段 |
| --- | --- | --- | --- |
| Tab 插入空格 | Tab | 僅正文，沿用空格數與全半形設定；候選開啟時優先接受候選；其他控制項保留焦點巡覽 | P1，保留 |
| 換行／純換行 | Enter／Shift+Enter | 保留行首自動留空差異；IME Enter 先提交中文；候選接受優先於換行 | P1，保留 |
| 插入／覆寫切換 | Ins | 僅正文且允許覆寫；無 Ins 的鍵盤可用狀態列，不另占系統按鍵 | P1，保留 |
| 候選清單 | ↑／↓、適用時 ←／→、Enter／Tab、Esc | 沿用 Poppin 的移動、階層、接受、取消規則；未有對應階層時放行文字導覽；IME 組字時不接管 | P1，保留 |
| Mention 移動／刪除 | ←／→、Backspace／Delete | 沿用 atomic selection／delete，快捷鍵層不自行算 raw offset | P1，保留 |
| 插入短語 `phrases.insert` | Mod+Shift+L | 共用既有插入短語入口；需可編輯正文目標，保留選區後開啟挑選器 | P2，新增綁定 |
| 短語庫 `phrases.library` | 既有 Ribbon 按鈕；保留 `;;`、`/`、`\` 觸發方式 | 短碼為文字輸入功能，不以全域鍵盤事件模擬；沿用既有範圍及 IME／貼上限制 | P2，命令整合 |
| 選取存為短語 `phrases.saveSelection` | 既有 Ribbon 按鈕，預設不綁定 | 僅正文有效非空選區；使用入口時捕捉的目標與選區 | P2，命令整合 |
| 新增／編輯標記、標點面板、修訂面板 | 各功能既有入口，預設不綁定 | 先建立各功能 adapter；標記尊重 UUID／原子邊界，修訂只開啟介面 | P2，新增 adapter |

正文是純文字持久化，不加入 Ctrl／⌘+B、I、U 等富文字格式快捷鍵。修訂接受／拒絕、永久刪除、同步發送與 Copilot 送出不預設配置全域按鍵。

### 2.4 導覽、檢視與說明

| 命令／功能 | Windows／Linux | macOS | 作用域與行為 | 階段 |
| --- | --- | --- | --- | --- |
| 命令清單 `app.commands.open` | 暫不註冊 | 暫不註冊 | 通用命令清單暫緩；不占用原提議的 Ctrl+Shift+P／⌘⇧P，也不作為模組切換器的依賴 | 暫時不考慮 |
| 開啟模組切換器 `module.switcher.open` | Ctrl+Shift+M | ⌘⇧M | 與「切換模組」按鈕開啟同一個模組清單，詳見 2.5 | P1，新增 |
| 上一個／下一個 Ribbon 頁籤 `ribbon.tab.previous`／`ribbon.tab.next` | Alt+←／Alt+→ | ⌥←／⌥→ | 依可見頁籤順序切換；正文與 Ribbon 焦點下意義相同，不觸發頁籤內命令 | P1，新增 |
| 上一個／下一個模組 `module.previous`／`module.next` | Alt+↑／Alt+↓ | ⌥↑／⌥↓ | 依固定模組順序循環，包含首頁、設定、說明；在 Ribbon 焦點下仍切模組 | P1，新增 |
| 快速切換章節 `chapter.quickOpen` | Ctrl+P | ⌘P | 開啟依名稱搜尋的章節清單；選取時共用現有章節切換；目前無列印功能，若未來新增須重評此配置 | P2，需新增介面 |
| 前／後章節 | Ctrl+PageUp／PageDown | ⌘⇧[／] | 僅正文／章節工作區；依既有深度優先章節順序，略過資料夾、不循環、不建立專案內容交易 | P2，新增 adapter |
| 章節重新命名／刪除 | F2／Delete | F2／Delete | 僅章節樹節點焦點；欄位編輯時保留文字功能；刪除沿用既有確認及引用檢查 | P2，新增綁定 |
| 切換側邊欄 `view.sidebar.toggle` | Ctrl+B | ⌘B | 僅無 modal 的桌面工作區，沿用現有側邊欄切換；窄版不註冊此綁定 | P2，新增綁定 |
| 導覽列、儀表板、標點 | 既有按鈕 | 既有按鈕 | 保留顯示區塊與標點入口；各功能頁統一由模組切換器提供導覽 | P2，命令整合 |
| 情境說明／點選求助 | F1／Shift+F1 | F1／Shift+F1 | 保留 HelpController；視鍵盤可能需 Fn，仍有選單入口 | P1，已有 |
| Ribbon 展開／收合 | Ctrl+F1 | ⌘F1（建議） | Windows／Linux 提升為工作區命令；macOS 由宿主提供，驗收 Fn 與系統攔截；不可同時與套件處理兩次 | P2，整合 |
| 進入 Ribbon KeyTip | F10；單獨 Alt 作為後續增強 | 選單；F10 經平台驗收再開放 | 保留 Ribbon 區內既有能力；全工作區入口要能保存／恢復正文焦點 | P2，整合 |
| Ribbon 頁籤導覽 | ←／→、Home／End、Ctrl+Tab／Ctrl+Shift+Tab | 相同，僅 Ribbon 內 | 僅頁籤導覽焦點；不接管正文或 Ribbon 文字輸入／popup 的按鍵 | P2，修正邊界 |

單獨 Alt 必須在按鍵釋放時確認沒有形成其他組合，且排除 AltGr；Alt＋方向鍵的按下與釋放均不觸發 KeyTip。macOS 不攔截單獨 Option，但依使用者指定，Option＋方向鍵用於本計畫的導覽。若套件無法停用重疊 handler，先修改本機套件，不在宿主疊加第二份處理。Ctrl+F1、KeyTip 與三種工具列模式的結果應以宿主 toolbar mode 為準。

### 2.5 模組切換按鈕、快捷鍵與模組清單

首頁、設定、說明均為一級模組，與故事、章節等功能使用相同的切換機制。說明中心與「關於」是兩個不同模組；正文也納入目錄，讓窄視窗能透過相同入口回到寫作畫面。

**按鈕與切換器：**

- 在頂部工具列共用動作區新增「切換模組」按鈕，顯示模組圖示、目前名稱與下拉提示；Full／Moderate／Concise 均可見，不依賴目前 Ribbon 頁籤或導覽列顯示狀態。窄視窗縮為圖示按鈕，保留 tooltip 與無障礙名稱「切換模組，目前為……」。
- 點擊按鈕或按 Mod+Shift+M 開啟相同清單。桌面使用錨定 popup；可用空間不足時使用對話框。這是只列模組的導覽清單，與暫不考慮的通用命令清單分開。
- 所有模組均有圖示、名稱、目前選中標記與可用的直接快捷鍵；首頁在上方，創作模組在中段，設定／說明／關於在底部。以同一份目錄產生按鈕清單、側邊導覽與快捷鍵標籤。
- 可用文字搜尋模組，↑／↓ 移動、Enter 確認、Esc 取消；組字中的 Enter 先交給 IME。移動選取只預覽清單焦點，確認前不切頁；取消回到原控制項與選區。
- 選中目前模組只關閉清單並聚焦原模組，不重建畫面或重設捲動。開啟清單期間，模組循環與直接跳轉鍵不穿透背景。

下表同時定義模組循環順序與直接鍵的預設配置；`—` 表示仍可透過切換按鈕、切換器與前後循環抵達，P3 可自訂直接鍵。數字鍵綁定固定命令 ID，不隨排序、搜尋結果或隱藏狀態改變。

| 順序 | 模組 ID（擬新增） | 名稱 | 直接快捷鍵 | 現有入口／實作方向 |
| --- | --- | --- | --- | --- |
| 1 | `home` | 首頁 | Mod+0 | 對接現有 Welcome 頁 |
| 2 | `story` | 故事設定 | — | 對接現有故事基本資料頁 |
| 3 | `chapters` | 章節選擇 | Mod+2 | 對接現有章節樹 |
| 4 | `outline` | 大綱調整 | Mod+3 | 對接現有大綱頁 |
| 5 | `timeline` | 時間軸 | Mod+6 | 對接現有時間軸頁 |
| 6 | `characters` | 角色設定 | Mod+4 | 對接現有角色頁 |
| 7 | `relationships` | 關係設定 | — | 對接現有關係圖頁 |
| 8 | `world` | 世界設定 | Mod+5 | 對接現有世界頁 |
| 9 | `items` | 物品設定 | Mod+7 | 對接現有物品頁 |
| 10 | `plans` | 計畫規劃 | — | 對接現有企劃頁 |
| 11 | `glossary` | 詞語參考 | — | 對接現有詞語頁 |
| 12 | `palettes` | 文字色票 | — | 對接現有色票頁 |
| 13 | `proofreading` | 文本校正 | — | 對接現有校稿頁 |
| 14 | `copilot` | Copilot | — | 僅切換頁面，不送出對話或啟動任務 |
| 15 | `editor` | 正文編輯 | Mod+1 | 對接目前正文工作區；未選章節時顯示既有空狀態，不自動新增章節 |
| 16 | `settings` | 設定 | Mod+8；Mod+, | 共用設定模組命令，不另維護第二條設定導覽路徑 |
| 17 | `help` | 說明 | Mod+9 | 新增可嵌入工作區的說明模組，共用離線目錄、搜尋與文章內容 |
| 18 | `about` | 關於 | — | 保留現有關於頁與授權資訊 |

**切換行為與實作邊界：**

1. 新增 `AppModuleId` 與 `AppModuleDefinition`，定義穩定 ID、標題、圖示、順序、分組及 availability。`module.open.<id>`、`module.next`、`module.previous` 與 UI 全部呼叫同一個 module controller。
2. 第一階段以 ID adapter 對接目前 0–15 頁面索引及正文的特殊索引；不要直接重排既有數字，避免影響 HelpTopic、歷史與各處跳轉。將 `_destinationKeys` 的固定長度、`slidePageCounts`、`1..13` 中段範圍及 `14/15` footer 等假設改由目錄推導，再加入說明模組。
3. 切換前共用正文同步與現有頁面導覽邏輯；回到模組時保留章節、選區、捲動及模組自身輸入狀態。桌面切換功能模組時保留既有正文分欄行為；窄版切到 `editor` 才進正文畫面。
4. 模組循環依上表順序，末尾回到首頁、首頁反向回到關於；只略過 build／平台明確不可用的模組，不因沒有章節就略過正文。首頁、設定、說明永遠包含在一般工作區目錄。
5. Alt+↑／Alt+↓ 在工作區切模組，包含 Ribbon 焦點；切換器、對話框、Help picker 或 IME 組字期間不循環。每次 keydown 只切換一次，不接受長按 repeat。Ctrl+Tab／Ctrl+Shift+Tab 不再預設綁定模組切換，Ribbon 內原有局部頁籤導覽可保留。
6. 將 HelpViewer 的目錄、搜尋、文章與瀏覽歷史抽成可嵌入的共用內容；說明模組不使用 `Navigator.pop()` 關閉工作區，也不啟用 modal 的 `isShowing` 輸入阻擋。模組頁面依可用容器寬度排版，維持整體模組導覽可操作。
7. F1／Shift+F1 保留既有情境說明與點選求助對話框，關閉後回原控制項；Mod+9 與模組清單選「說明」則進說明模組。兩種呈現共用同一份 HelpCatalog，使用不同 FocusNode 與瀏覽狀態，避免同時掛載同一焦點節點。
8. `HelpTopicId.forPage` 及模組 HelpScope 對應一併調整，說明模組使用 `help.home`／`help.using` 的既有主題，不複製第二份說明 JSON；「關於」持續對應原本主題。

模組切換屬於 P1；P0 先建立目錄與 adapter。通用命令清單維持暫不考慮，不作為模組切換或其他快捷鍵交付的前置條件。

### 2.6 Alt＋方向鍵的統一導覽

| 按鍵 | 命令 | 操作結果 |
| --- | --- | --- |
| Alt+← | `ribbon.tab.previous` | 選取前一個可見 Ribbon 頁籤 |
| Alt+→ | `ribbon.tab.next` | 選取下一個可見 Ribbon 頁籤 |
| Alt+↑ | `module.previous` | 切換至上一個可用模組 |
| Alt+↓ | `module.next` | 切換至下一個可用模組 |

**共同規則：**

- 直接執行切換，不需先按 F10、聚焦導覽列或開啟切換器；不需要 Enter 再確認。左右只改 Ribbon 頁籤，上下只改模組，兩個軸向各自保持原有選取。
- Ribbon 依目前可見頁籤順序循環，包含「檔案／常用／搜尋」；模組依 2.5 的完整順序循環。開頭反向回末尾、末尾正向回開頭；只有一個可用項目時不切換。
- Full／Moderate／Concise 都使用同一套命令。切 Ribbon 頁籤不強制展開／收合工具列，不開啟檔案對話框或執行選中的命令，也不把「切到搜尋頁籤」當成執行搜尋。
- 左右切頁時保存目前輸入框的焦點、選區與捲動，不把鍵盤焦點強制移入 Ribbon。上下切模組時走同一個 module controller，先同步正文，再恢復目的模組可用的焦點；不將上一模組已隱藏的輸入框重新聚焦。
- 沒有 modal、popup、Help picker 或 composing 時，正文、搜尋框、一般欄位及 Ribbon 都能執行相同四個命令。此配置刻意優先於 App 內原本的 Alt／Option＋方向鍵文字移動或頁面歷史操作；不加 Alt 的方向鍵仍由原控制項處理。P3 可取消或重新綁定這四個導覽鍵。
- 模組切換器、其他 popup、modal、IME 組字或 Poppin 候選開啟時，不執行背景 Alt 導覽；保留當前互動的按鍵處理。已顯示的 Ribbon KeyTip 在合法 Alt 導覽前退出，按鍵只切一次，Alt 釋放後不重新進入 KeyTip。
- 僅匹配 Alt＋單一方向鍵，Ctrl／Meta／Shift 均不得同時按下，排除 AltGr；`includeRepeats: false`。Windows／Linux 可接受左右 Alt，macOS 為左右 Option，但平台輸入法辨識為 AltGr 的事件不得當作導覽。

**接線與套件修正：**

1. 四個命令由宿主集中定義；根層快捷鍵、正文兩種 editor adapter、一般輸入 scope 與 Ribbon 共用同一命令。確保編輯器預設的 Alt／Option 文字移動不先消費這四個組合；只轉接精確組合，不另寫攔截所有按鍵的全域 listener。
2. 本機 `material_ribbon` 目前在 Alt 的 KeyDown 立即切換 KeyTip，且左右方向鍵處理未排除修飾鍵。P1 必須先修正這兩處：單獨 Alt 的可選 KeyTip 入口延後到 KeyUp，記錄期間是否使用組合鍵；普通方向鍵與宿主 Alt 導覽分開匹配。
3. 宿主 Alt 導覽與套件 `_onKey` 只能有一方消費事件，成功後不再傳遞；不可因 KeyTip、Ribbon callback 與根層 Action 各執行一次而跳過頁籤／模組。F10 仍保留既有 KeyTip 入口。
4. 以宿主可控制的 Ribbon controller／頁籤選取 adapter 更新狀態，驗證切頁 API 的焦點副作用；必要時調整本機套件，讓選取頁籤與要求焦點分開控制。

Alt 導覽與上述必要套件修正納入 P1，不能延到 P2 才處理。模組切換按鈕、Mod+Shift+M 與 Mod+數字的直接跳轉配置保留。

## 3. 命令與快捷鍵架構

採用 Flutter `Shortcuts` → `Intent` → `Action`，Action 再呼叫 App 自有 dispatcher。按鈕、Ribbon、快捷鍵與模組切換器共用命令 ID 與同一執行邊界；`material_ribbon` 僅作呈現 adapter。通用命令清單暫不納入交付。現有 `_invoke` 仍保留防禦檢查，但跨入口 busy 不再只存在於 AppBar widget。

以下路徑均為擬新增，第一階段僅建立核心需要的檔案，不一次抽象所有功能：

| 路徑（相對 `dart_edition/lib/`） | 職責 |
| --- | --- |
| `features/commands/app_command.dart` | 穩定命令 ID、標題、類別、適用目標、執行條件與停用原因 |
| `features/commands/app_command_dispatcher.dart` | 驗證執行條件、互斥群組、捕捉與驗證目標、等待 Future、錯誤／取消結果 |
| `features/navigation/app_module.dart` | 模組 ID、標題、圖示、固定循環順序、分組與平台可用條件 |
| `features/navigation/app_module_controller.dart` | 模組直接跳轉、前後循環、舊索引 adapter、正文同步與導覽狀態 |
| `features/navigation/ribbon_navigation_adapter.dart` | P1 加入；依可見順序切換 Ribbon 頁籤，控制焦點副作用，避免重複派送 |
| `features/shortcuts/shortcut_binding.dart` | 可序列化的按鍵、修飾鍵、平台、scope、repeat policy；從資料產生 `SingleActivator` |
| `features/shortcuts/default_shortcut_bindings.dart` | 集中預設按鍵與平台差異，支援一個命令多個別名 |
| `features/shortcuts/app_shortcut_scope.dart` | 工作區／正文／搜尋／章節樹等作用域接線；不以單一全域 listener 取代文字輸入 |
| `presentation/providers/shortcut_providers.dart` | 預設與自訂綁定合併、可用命令狀態；使用 select 避免每次按鍵重建整個工作區 |
| `data/repositories/shortcut_preferences_repository.dart` | P3 才加入；沿用 app-local SharedPreferences 儲存模式 |
| `presentation/widgets/module_switcher.dart` | P1 加入；切換按鈕、模組搜尋、目前模組標記、鍵盤操作與回焦 |
| `features/help/help_content.dart` | P1 抽取；供說明模組與既有 Help 對話框共用的目錄／搜尋／文章內容 |
| `presentation/widgets/settings/shortcut_settings.dart` | P3 才加入；錄製按鍵、分類搜尋、衝突檢查與重設 |

第一批以 adapter 接回 `_newProject`、`_openProject`、`_saveProject`、`_saveProjectAs`、搜尋 callbacks 及編輯器命令橋接，不要求先搬離所有 `main.dart` 業務程式。既有工具列的短 ID（例如 `save`）可暫時映射成 `project.save`，避免一次改動所有 UI 與 Help topic。

Dispatcher 建議回傳 `succeeded`、`cancelled`、`unavailable`、`failed` 及可供 UI 顯示的原因。現有 `Future<void>` handler 先逐步接入；若內部取消或捕捉錯誤未往外回傳，必須補結果 adapter，不能將 Future 結束一律顯示為儲存成功。

## 4. 作用域、焦點與非同步規則

採「模式保護 → 目前互動區域 → 工作區」的原則；IME 與 OS 接收的鍵盤事件不一定都會傳給 Flutter，不用全域 early handler 搶回文字輸入按鍵。

1. **點選求助與說明**：保留 HelpController 的現有輸入阻擋，求助模式不讓儲存、Enter 或字母穿透；F1／Shift+F1 的現有行為維持。
2. **Modal 與 popup**：最上層對話框／選單先處理自己的輸入、剪貼簿及 Esc。背景專案切換、匯入、檢視切頁等命令不可穿透；使用 route／focus scope 與 dispatcher 雙重檢查，不能只依賴 widget 祖先關係。
3. **IME 與候選**：正在 composing 的欄位先擁有 Enter、Tab、Esc、方向鍵等輸入操作。會改變焦點、正文或專案的命令暫停，要求提交組字後重試；不自行清空 composing。Copy 等不修改目標的標準欄位操作保留原有行為。
4. **一般欄位與正文**：標準編輯鍵交由目前焦點欄位；正文專用操作透過 Quill／CodeField adapter。鍵盤輸入使用當前焦點，不沿用過期的 `_lastFocusedEditableNode`；工具列與模組切換器才使用入口時捕捉的有效目標。
5. **Esc**：每次只處理一層。由當前模式及焦點決定關閉 Help／modal／popup／Poppin／KeyTip；上述皆未消費時才關搜尋並回焦，不能同時關閉兩個區域。
6. **工作區命令**：新建、開啟、儲存、另存、匯入／匯出共用 `projectIo` 互斥群組，包含原生選檔與未儲存確認期間。I/O provider 的 `isBusy` 及 session coordinator 仍是底層依據。

離散操作（開對話框、切換顯示、貼上、取代、儲存）採 `includeRepeats: false`；移動游標／候選與連續復原可保留 repeat，但重入檢查必須生效。即使兩次按鍵都是 KeyDown，也要由執行邊界避免並行開出兩個選檔視窗。

保存焦點時記錄可驗證的 FocusNode／adapter、專案 session、章節與選區。非同步完成時若使用者已換章節、切專案或目標已 dispose，放棄回寫／回焦；純檢視操作不新增作品 dirty、P2P delta 或內容歷史交易。章節／頁面導覽若已有獨立導覽歷史，維持其現行契約。

## 5. 自訂與可發現性

P1 先讓 tooltip 和快捷鍵說明共用預設綁定，並提供可搜尋的模組切換器；沒有預設快捷鍵的功能繼續使用既有按鈕。通用命令清單暫不考慮。P3 再提供「設定 → 編輯與輸入 → 快捷鍵」。

- 顯示類別、功能、目前按鍵、平台與作用域；支援依功能名／按鍵搜尋、清除綁定、單項重設與全部重設。
- 儲存版本化資料，例如 `{schemaVersion, bindings: [{commandId, platform, scope, keys}], disabledDefaults: [...]}`。明確區分「尚未自訂」與「使用者取消預設按鍵」。
- 按 scope 與同時啟用條件檢查衝突；工作區與其子 scope 也可能重疊，不只比較完全相同的 scope。重複的標準欄位快捷鍵不能當成一般 App 命令覆蓋。
- 同時檢查預設、別名與自訂項；不允許同一有效情境下無聲覆蓋。列出衝突命令，明確選擇取代或取消。
- F1／Shift+F1、純文字輸入字母、單獨修飾鍵、Tab／Enter／Esc 的基礎導覽保留；OS 攔截的組合只能顯示已知限制，不能保證所有桌面環境都能接收。
- 偏好只存在本機，不寫入 `.mnproj`／協作 schema；未知舊命令 ID 保留或隔離，暫時無可用目標的命令仍保有設定。
- 工具列 Full／Moderate／Concise 的提示字串與實際按鍵一致；靜態說明 JSON 保留原理與情境，動態清單顯示目前實際設定，避免自訂後說明失真。

## 6. 實作順序與交付條件

以下工作量為熟悉專案的一名工程師粗估，不含新功能本身的大幅改寫與等待實機環境時間。

| 階段 | 交付內容 | 完成條件 | 粗估 |
| --- | --- | --- | --- |
| P0：基礎整理 | 命令與模組目錄、舊頁面索引 adapter、平台綁定、作用域與 dispatcher；先遷移既有 N／O／S／F／Z／Shift+Z 及編輯器標準命令 | 原有行為與保護不退步；按鈕／鍵盤共用互斥，單次按鍵不重複執行 | 2–3 人日 |
| P1：日常快捷鍵與模組切換 | 另存、搜尋聚焦、取代展開、結果導覽、Ctrl+Y；切換模組按鈕、Alt＋四方向導覽與直接鍵，納入首頁／設定／說明／正文；抽取可嵌入說明內容；修正套件 Alt／KeyTip 與方向鍵重複處理 | 兩種編輯器、一般欄位、三工具列模式及窄版測試通過；模組完整可達、切換不遺失輸入；F1 保持情境求助；Alt 導覽不觸發 KeyTip 或重複執行 | 4–6 人日 |
| P2：創作導覽 | 匯入匯出、快速章節切換、章節操作、短語與面板 adapter、Ribbon 接線；不包含通用命令清單 | 原選區與回焦正確；章節切換不遺失文字；Ribbon 不攔截文字欄位；跨平台人工驗收 | 3–5 人日 |
| P3：個人化 | 按鍵錄製、衝突解決、版本化保存、重設與動態說明 | 重啟保留；未知 ID／舊資料／取消綁定可復原；多平台設定互不誤套 | 2–4 人日 |

加入模組切換、說明模組及 Alt 導覽必要套件修正後，建議先交付 P0＋P1，約 6–9 人日；完成全部範圍粗估 11–18 人日。每階段可獨立交付；通用命令清單不列入估算，自訂設定也不是常用快捷鍵的前置條件。

## 7. 驗證與發布

新增少量直接驗證行為的測試，不為每個只轉呼叫的 handler 建立重複測試。

| 測試面向 | 必須驗證的行為 | 既有測試／擬新增位置 |
| --- | --- | --- |
| 綁定解析 | macOS 用 Meta，Windows／Linux 用 Control；Shift 不誤觸無 Shift 命令；Ctrl+Y 別名、重複鍵與重疊 scope 衝突 | 擬新增 `test/shortcut_bindings_test.dart` |
| 命令邊界 | 停用不可經任何入口執行；鍵盤＋Ribbon 重入只執行一次；取消不回報成功；session 切換後舊 async 不落地 | 擬新增 `test/app_command_dispatcher_test.dart`；沿用 `test/providers/project_io_status_test.dart` |
| 文字目標 | Quill／CodeField／一般 TextField 各自剪貼簿與歷史正確；焦點從搜尋框轉回正文不操作錯誤目標 | `editor_toolbar_quill_test.dart`、`editor_text_box_mosaic_clipboard_test.dart`、`plain_text_quill_editor_poc_test.dart` |
| 搜尋 | 連按 Mod+F 保持開啟；取代可展開並聚焦；Enter 導覽不換行；Esc 只關一層；最新查詢的結果才可取代 | 擬新增 `test/app_shortcuts_test.dart`；沿用 `findreplace_ime_test.dart`、`findreplace_latest_wins_test.dart`、`search_ribbon_test.dart` |
| 中文與候選 | composing 期間 Enter／Esc／方向鍵不執行 App 命令；候選接受優先於正文換行與 Tab；Mention 原子邊界不破壞 | `editor_input_modes_test.dart`、`editor_text_box_mosaic_intellisense_test.dart`、`poppin_navigation_test.dart` |
| 模組切換 | 按鈕與快捷鍵共用入口；18 個模組完整可達；首頁／設定／說明含在 Alt+↑／↓ 循環；Mod+0／8／9 正確；macOS 不攔截 ⌘Tab；搜尋取消不切頁；長按不連切；模組排序不改直接鍵目標 | 擬新增 `test/module_navigation_test.dart`、`test/module_switcher_test.dart`；沿用 `navigation_layout_test.dart` |
| Alt 導覽 | 左右只切 Ribbon、上下只切模組；正文／一般欄位／Ribbon 焦點皆一致；頁籤首尾循環且左右切頁不搶焦點；Alt 釋放不啟動 KeyTip；額外修飾鍵、AltGr、repeat、composing、候選與 modal 不誤觸；只切一次且不執行任何頁籤內命令 | 擬新增 `test/alt_navigation_test.dart`；補本機 Ribbon 套件測試與兩編輯器整合測試 |
| 模組狀態與說明 | 切換後正文／欄位內容、選區與捲動保留；窄版可回正文；說明嵌入時仍能切其他模組；F1 modal 與說明模組共用內容且焦點互不衝突；關於仍獨立可達 | 擬新增 `test/help_module_test.dart`；沿用 `help_test.dart`、`help_editor_integration_test.dart` |
| 說明與對話框 | Help picker 阻擋命令；F1 不重複開窗；modal 不穿透到背景；關閉後原控制項可繼續操作 | `help_test.dart`、`help_editor_integration_test.dart` |
| 個人化 | 自訂、停用、重設、舊 schema、未知 ID、別名及 scope 衝突；tooltip／清單反映實際配置 | P3 擬新增 `test/shortcut_preferences_test.dart` |

每一階段執行 `flutter analyze` 及受影響測試。已實作項目加入 `alt_navigation_test.dart`、`module_navigation_integration_test.dart` 與 `ribbon_keyboard_navigation_test.dart`，並與既有說明、搜尋、編輯器及版面測試一起驗證；測試證據另見下方實作紀錄。

發布前在 Windows、macOS、Linux 實機檢查：中文輸入法、AltGr、功能鍵／Fn、系統保留鍵、原生選檔期間的命令阻擋、長按與跨入口重入、失敗／取消回饋、重新聚焦，以及 Full／Moderate／Concise 和窄視窗。行動版外接鍵盤另列驗收結果。

## 8. 程式與官方參考

- [主畫面與現有快捷鍵](../dart_edition/lib/main.dart)、[Ribbon 命令與執行邊界](../dart_edition/lib/bin/appbar.dart)、[現有模組導覽](../dart_edition/lib/bin/slidebar.dart)。
- [正文與候選接線](../dart_edition/lib/bin/content.dart)、[Quill 命令橋接](../dart_edition/lib/features/editor/plain_text_quill_editor_poc.dart)、[搜尋與取代](../dart_edition/lib/bin/findreplace.dart)。
- [HelpController](../dart_edition/lib/features/help/help_controller.dart)、[HelpViewer](../dart_edition/lib/features/help/help_viewer.dart)、[Help topic 對應](../dart_edition/lib/features/help/help_topic.dart)、[I/O provider](../dart_edition/lib/presentation/providers/project_io_providers.dart)、[離線快捷鍵說明](../dart_edition/assets/help/zh_TW.json)。
- Flutter 官方：[Actions and Shortcuts](https://docs.flutter.dev/ui/interactivity/actions-and-shortcuts)、[SingleActivator](https://api.flutter.dev/flutter/widgets/SingleActivator-class.html)、[ShortcutManager](https://api.flutter.dev/flutter/widgets/ShortcutManager-class.html)。此處架構為依官方機制提出的專案設計；實作時以專案 SDK 編譯與測試結果確認相容性。


## 9. 首批實作紀錄

本輪依使用者要求實作 Alt＋方向鍵與完整模組導覽，並接入日常快捷鍵。導航共用 AppModule 目錄與宿主操作方法，暫未抽取提案中的完整 AppCommandDispatcher／個人化儲存層；P2 創作工作流及 P3 自訂按鍵仍為後續工作。

- 已實作：18 個模組、固定按鈕與可搜尋切換器、Alt＋四方向、Mod＋數字與設定別名、說明模組與 F1 對話框並存、另存快捷鍵、搜尋固定聚焦／取代展開／結果導覽／Esc、非 Apple 平台 Ctrl+Y。
- 套件調整：控制器切頁可保留焦點、固定 header action、宿主可停用單獨 Alt KeyTip、Alt 釋放判斷、方向鍵修飾鍵與文字欄位邊界。窄視窗狀態列改為可橫向捲動，避免既有固定資訊列溢位。
- 說明同步：[使用說明](GUIDE.md#模組切換與鍵盤導覽)、[內部 API](API.md#10-工作區模組與快捷鍵導覽)、內建 `help.shortcuts`／`toolbar.overview` 主題。
- 測試涵蓋 Windows／macOS／Linux 按鍵解析、三種 Ribbon 模式、390／1600 寬度、真實 Quill、一般輸入框、IME／modal、F1 與說明模組焦點、選區保留及套件 Alt 行為。這些是 macOS 上的 Flutter 自動化測試，仍需各平台實機驗收。


### 驗證結果（2026-11-01）

| 項目 | 結果 |
| --- | --- |
| 既有導覽、說明、搜尋、編輯器、專案重設與狀態列回歸（含新增搜尋 Enter／IME 案例） | 75 項通過。 |
| 新增 Alt 導覽、模組工作區與 Ribbon 套件鍵盤測試 | 13 項通過，涵蓋三種工具列模式及 390／1600 寬度。 |
| 新增 Quill 另存快捷鍵與重複輸入防重入 | 1 項通過；確認 Mod+Shift+S 不落到 Quill 刪除線格式。 |
| 最終版本說明／搜尋／導覽重驗 | 43 項通過，與上述測試重疊，不重複計數。 |
| `flutter analyze --no-pub` | 0 error、0 warning；目前工作區仍有 183 項 info 層級提示。 |
| `git diff --check`、離線說明 JSON、文件本機連結 | 通過；64 個 Help topic ID 保持唯一。 |

合計 89 項不同案例通過。本次不是全測試套件執行；測試環境為 macOS，Windows／Linux 原生鍵盤、Fn／AltGr 與平台輸入法仍需實機驗收。工作區同時存在其他未提交變更，以上分析數量僅代表記錄當時狀態。
