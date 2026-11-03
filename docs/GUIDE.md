# Monogatari Assistant 統一說明文件

更新日期：2026-11-02

適用版本：App `0.9.31`；專案格式 `1.22`

[文件中心](README.md) · [API 文件](API.md) · [參考文件索引](SOURCES.md)

## 1. 專案介紹

Monogatari Assistant（物語 Assistant／MonoAshi）是以 Flutter 開發的故事創作工具，把正文、章節、大綱、角色、世界觀、物品、時間軸與校稿資料放在同一個工作區。作品主要保存為本機 `.mnproj` 專案檔。

原始碼採 [Apache License 2.0](../LICENSE.md)。名稱與標誌的使用另見 [商標說明](../TRADEMARKS.md)，第三方聲明見 [NOTICE](../NOTICE.md)。

## 2. 功能與目前範圍

| 功能 | 用途與行為 |
| --- | --- |
| 故事設定 | 保存作品名稱、作者、簡介、類型及基本企劃資料 |
| 章節與正文 | 用資料夾／章節樹組織稿件，編輯、排序與匯出正文 |
| 大綱與時間軸 | 管理故事線、事件、Scene 和 placement，依 Tick 查看故事狀態 |
| 角色與關係圖 | 保存角色檔案、關係與 Scene 狀態變更 |
| 世界設定 | 保存階層式地點、設定欄位及地點快照 |
| 物品 | 管理 Class、instance、歸屬、數量、正式關聯與歷史快照 |
| 搜尋與取代 | 提供一般文字、正則表示式、大小寫、全半形及忽略字元選項 |
| 標記與短語 | 正文中的 UUID 標記、註記、顯示投影，以及專案短語庫與 PoppinSense 插入 |
| 企劃與校稿 | 整理伏筆、更新計畫與正文檢查資料 |
| 修訂追蹤 | 比較正文與結構化資料，保存本機 checkpoint，檢視與處理支援的差異 |
| Copilot | Chat 與依 build 開關提供的 Ask／Plan；使用自備 API Key 直接連到 provider |
| MCP | 授權本機 Host 唯讀查看作品，提供 7 個工具與 resource URI |
| P2P／協作 | 內網端點探測、配對、加密快照交換與即時協作資料流 |

Copilot Ask／Plan 預設由編譯旗標關閉；Plan 只提供建議、驗證、檢視及匯出，Agent 尚未開放。Git 同步與 Sync Hub 等替代架構仍屬設計參考，不能依計畫文件推定已提供。

### 工具列模式

可從工具列的「工具列模式」選單，或「設定 → 外觀與介面 → 工具列模式」切換：

| 模式 | 呈現 |
| --- | --- |
| Full | 完整 Ribbon，含常用／檔案／搜尋頁籤、靠左排列的命令群組與快速存取列；桌面預設。 |
| Moderate | 保留相同 Ribbon 頁籤，該頁指令以單行圖示＋文字按鈕顯示，可橫向捲動；Android／iOS 預設。 |
| Concise | 保留相同頁籤，該頁指令以單行純圖示顯示，可橫向捲動；停留或聚焦時提供 tooltip。 |

設定頁的主題、導覽與工具列模式皆以介面預覽卡選取，選中時顯示外框與勾選標記。設定分類為外觀與介面、編輯與輸入、儲存與備份、同步與連線、一般設定、外部整合；點擊分類標題可展開或收合。

「自動」依裝置平台選擇桌面 Full／手機 Moderate；手動選擇優先於平台預設，重新啟動後保留。Full 的收合按鈕切換至 Concise，Moderate／Concise 的展開按鈕切換至 Full；切換模式時保留目前頁籤。新建、開啟、另存、匯入與匯出均位於「檔案」頁。模式只保存於本機設定，不寫入作品或同步資料。

頁籤排列為「檔案 → 常用 → 搜尋」，首次開啟預設選取「常用」。Full 的檔案頁將「儲存檔案」排在最前，旁邊以同一直向欄位排列新建、開啟、另存；Moderate／Concise 保持新建、開啟、儲存、另存的順序。

### 離線說明與 F1

工具列「說明」選單提供說明首頁、目前功能說明及「這是什麼？」點選求助，三種工具列模式皆可使用。

| 操作 | 行為 |
| --- | --- |
| F1 | 依目前焦點開啟控制項、功能區或頁面說明；找不到對應內容時回到說明首頁。 |
| Shift+F1 | 顯示問號游標，點選控制項只開啟說明，不執行原操作；再次按下可取消。 |
| Esc | 取消點選求助，或關閉最上層說明對話框。 |
| Ctrl+F1 | 焦點在 Ribbon 時沿用展開／收合操作。 |

說明中心內建繁體中文內容，無須網路。使用搜尋、分類目錄、相關說明及上一頁／下一頁瀏覽；窄視窗採全畫面並切換目錄與文章。關閉後返回原控制項，原本開啟的操作對話框與尚未確認的選擇會保留。

全部功能頁都有說明。工具列、檔案、正文／搜尋及自動儲存／備份提供核心控制項主題；其他控制項先使用所屬區域說明。原生檔案選擇器由作業系統管理。若鍵盤功能鍵被系統攔截，請配合 Fn 或使用說明選單。

### 模組切換與鍵盤導覽

頂部工具列的「切換模組」按鈕可開啟模組清單；寬視窗顯示目前模組名稱，窄視窗顯示模組圖示。按鈕固定可見，不會隨 Ribbon 頁籤捲出畫面。清單可搜尋名稱，以方向鍵選擇、Enter 確認、Esc 取消；取消不會切頁。

模組包括首頁、故事設定、章節、大綱、時間軸、角色、關係、世界、物品、計畫、詞語參考、文字色票、校正、Copilot、正文、設定、說明與關於。首頁、設定及說明與其他功能使用相同切換方式。「說明」是可持續閱讀、搜尋的工作區模組；F1／Shift+F1 仍提供原有的情境求助對話框。

| 操作 | Windows／Linux | macOS |
| --- | --- | --- |
| 上一個／下一個 Ribbon 頁籤 | Alt+←／Alt+→ | Option+←／Option+→ |
| 上一個／下一個模組 | Alt+↑／Alt+↓ | Option+↑／Option+↓ |
| 開啟模組切換器 | Ctrl+Shift+M | ⌘⇧M |
| 直接開啟設定 | Ctrl+, | ⌘, |

Alt＋方向鍵直接切換，無須先聚焦工具列；首尾循環。左右切 Ribbon 時保留原輸入焦點與選區，不執行頁籤內命令，也不會因切到「搜尋」頁籤而自動開啟搜尋列。Full／Moderate／Concise 共用相同行為，macOS 的 Option＋方向鍵在工作區內優先用於此導覽。

直接跳轉使用 Ctrl+數字（macOS 使用 ⌘+數字）：`0` 首頁、`1` 正文、`2` 章節、`3` 大綱、`4` 角色、`5` 世界、`6` 時間軸、`7` 物品、`8` 設定、`9` 說明。其他模組可從切換器或 Alt+↑／↓ 抵達。切換正文不會自動建立章節。

中文組字、候選清單、選單、對話框、點選求助或載入專案期間不執行背景模組導覽；長按不連續跳頁。單獨 Alt 不啟動 App 的 KeyTip，焦點在 Ribbon 時可用 F10。一般方向鍵仍控制游標或目前控制項；Ctrl+Alt／AltGr 與加上 Shift／Command 的方向組合不屬於此導覽。

### 日常操作快捷鍵

Windows／Linux 使用 Ctrl，macOS 的字母快捷鍵使用 ⌘：新建 N、開啟 O、儲存 S、另存 Shift+S、復原 Z、重做 Shift+Z。Windows／Linux 也可用 Ctrl+Y 重做。全選 A、剪下 X、複製 C、貼上 V 依目前輸入框操作；正文保留純文字與標記邊界規則。

檔案、搜尋、模組導覽及 Undo／Redo 快捷鍵在 App 內全域生效，點選空白處或輸入框失去焦點後仍可使用。Undo／Redo 統一操作專案歷史；全選、剪下、複製、貼上仍由目前輸入框處理。對話框、選單、中文組字或專案作業進行中，優先處理目前操作，避免觸發背景命令。

單純切換模組不加入復原歷史，也不清除可重做的記錄；在新模組實際修改後，才於該修改前插入跳頁記錄。Undo 依序復原修改與跳頁，Redo 依序重播跳頁與修改。正文修改也保留跳頁記錄；桌面佈局因正文持續顯示，Undo／Redo 會跳過正文的跳頁步驟，復原正文時保留目前側欄模組。窄螢幕佈局則正常重播正文跳頁。

若切換到其他模組後按 Undo，第一次只回到目前歷史記錄所在頁面，保留尚未復原的修改及原有 Undo／Redo 位置；再次按 Undo 才復原內容。桌面佈局的正文仍直接復原，不額外跳頁。

Ctrl+F／⌘F 固定開啟並聚焦搜尋，再次按下會選取搜尋詞。Ctrl+H／⌘⌥F 展開並聚焦取代。Windows／Linux 用 F3／Shift+F3 查看下一個／上一個結果，macOS 用 ⌘G／⌘⇧G。搜尋框內也可用 Enter／Shift+Enter 導覽；中文組字時先提交文字。Esc 關閉搜尋並回到正文，若目前有候選或說明對話框則先處理該層。

檔案快捷鍵與工具列共用作業互斥，選檔、未儲存確認或存檔尚未完成時，不會重複開啟同一批操作。快捷鍵與模組導覽不影響專案 XML 格式；Windows／macOS／Linux 的系統攔截及實際輸入法仍需平台驗收。

內容隨 App 更新，瀏覽狀態僅保留於本次執行。Windows 實機操作仍需在發布前人工驗收；自動化測試不能代替平台驗收。

## 3. 建立、開啟與保存作品

### 初次設定（OOBE）

首次啟動會在啟動畫面之後顯示初次設定，依序介紹歡迎、介面偏好、儲存與備份、名稱設定、開始使用及完成。可選擇語言、主題、文字大小、側邊導覽、Ribbon 模式、自動儲存、自動備份及名稱；語言會立即保存，其餘引導草稿在按「開始創作」後保存，並記錄本機完成狀態，隨後進入工作區。未完成便關閉程式，下次仍會顯示並沿用已保存語言；已完成的裝置正常啟動時直接進入工作區。從檔案總管開啟的專案會等待引導完成後才載入。

每次顯示初次設定時，會先播放內建的 Intro（266 BPM，約 2.97 秒），再進入歡迎頁。影片保持原比例，周圍以白色填充；片尾最後約 0.45 秒，影片與白色填充一起淡出，露出目前主題的初次設定。影片可離線播放；載入失敗時直接顯示設定頁。播放 Intro 不會記錄引導完成，跳過引導也會一併跳過 Intro。

名稱設定可略過；略過會捨棄該頁尚未儲存的修改，沿用原有名稱與筆名偏好。勾選「作為預設筆名」後，新建專案的作者欄會自動填入該名稱，既有專案作者不受影響。名稱留空時不啟用預設筆名。可用 `--oobe/force` 重新開啟初次設定修改名稱。

Welcome 頁開頭依裝置本機時間顯示 `Good Morning/Afternoon/Evening/Night, {名稱}`：05:00–11:59 為 Morning、12:00–16:59 為 Afternoon、17:00–21:59 為 Evening，其餘時間為 Night；未設定名稱時顯示 `User`。開啟中的問候語會定期更新。

介面偏好頁的 Ribbon 模式與設定頁共用預覽卡，提供 Full、Moderate、Concise 及自動。自動依裝置選擇桌面 Full／手機 Moderate；重新開啟 OOBE 會帶入既有選擇，切回自動會移除手動偏好。完成頁會列出選擇的模式，完成引導後套用至工作區。

左上角使用 `Title.png`。第一頁的「顯示語言」提供跟隨系統、繁體中文、English 與日本語；設定頁「一般設定」也能切換。語言選擇會立即套用並自動保存在本機，不必重啟，也不必完成 OOBE。跟隨系統依裝置的偏好語言清單依序匹配繁中、英文或日文；全部不支援時使用繁中，中文各地區／字形變體目前均使用繁中版。手動選擇不受後續系統語言變更影響；儲存失敗會恢復最後成功保存的選擇並提示重試。

導覽、Ribbon、檔案與編輯操作、OOBE、設定及各功能模組使用繁中、英文、日文資源；說明中心依語系載入，繁中、英文與日文各提供完整 64 篇說明、167 個章節與 230 個操作步驟，無須網路。切換保留說明主題、歷史與搜尋文字。UI 字型、日期與數字顯示跟隨有效語系；時間採裝置本地時區與 24 小時制，數字、百分比及容量統一格式化，字型隨 App 內附，Quill 繁中資源明確對應到 `zh-TW`。切換保留目前模組、草稿、游標與復原記錄，不改寫作品內容或計數規則。專案格式 1.22 將六種內建角色類型轉為固定英文值，畫面仍以所選語言顯示；自訂類型保留原文。

主題模式、顏色與字體大小會即時套用於 OOBE；跟隨系統模式會隨作業系統明暗設定更新。字體大小使用 12–20 的 Slider；自動儲存及備份各有獨立開關與 1–120 分鐘間隔 Slider，關閉功能會停用 Slider 並保留原間隔。

可選擇自動備份資料夾，也能還原預設。自動儲存寫回各專案已知位置，自動備份另寫入選定的備份資料夾。選擇位置不會搬動既有檔案，取消選擇保留原設定；這些偏好也在完成引導時才保存。行動版沿用系統儲存流程與設定頁的備份資料夾選擇。

桌面啟動參數：

| 參數 | 行為 |
| --- | --- |
| `--oobe/force` | 即使已完成初次設定，仍重新開啟引導與 Intro，並帶入目前偏好。 |
| `--oobe/bypass` | 跳過本次引導與 Intro，首次使用也適用；不寫入完成狀態，下次正常啟動仍會顯示。兩個參數同時存在時優先跳過。 |

開發時在 `dart_edition/` 使用 `flutter run -d macos --dart-entrypoint-args=--oobe/force`（裝置可換成 `windows` 或 `linux`）；跳過則改為 `--dart-entrypoint-args=--oobe/bypass`。打包後將參數直接傳給應用程式執行檔；macOS 也可使用 `open -a "物語Assistant" --args --oobe/force`，須先完全結束原本執行中的程式。

### 建立與保存流程

1. 從歡迎頁建立或開啟專案，填寫故事基本資料。
2. 在章節頁建立資料夾與章節，選取章節後撰寫正文。
3. 依需要補上大綱、角色、地點、物品與術語等設定。
4. 使用「儲存」寫回目前位置，或以「另存為」建立新檔。
5. 從「檔案 → 匯出」選擇正文交稿（`.txt`／`.md`）、設定資料閱讀稿（`.md`）或局部專案交換（`.xml`），產生預覽後再儲存。

完整專案檔是 UTF-8 XML，副檔名為 `.mnproj`。TXT／Markdown 為閱讀內容；保留原始註記與資料結構的局部交換使用 XML。Word（DOCX）／PDF 已預留格式選項，目前停用。

章節、大綱、角色、地點與物品可展開 Checkbox 清單逐項選取。父列有全選／未選／部分選取三態，勾選父列包含全部後代；收合與搜尋不改變選取。大箱、中箱、地點與物品定義可用「僅此項」排除子項；物品實例會附帶必要定義。只選深層項目時保留祖先路徑，不包含未選兄弟內容。

檔案組織可選單一文件或分散文件 ZIP：正文每篇文稿一檔，依資料夾階層與同層混合順序保存；設定閱讀稿與交換 XML 每模組一檔。深層或過長路徑改存 `documents/` 短路徑，`export-manifest.json` 保留完整邏輯階層與順序。請先核對預覽及 ZIP 檔案樹，再選擇目的位置；取消儲存不顯示成功，失敗可重試。

取消模組勾選會清除該模組的子項勾選；展開或收合仍保留選取。閱讀稿會略過沒有內容的模組並顯示提示；全部選取範圍都沒有可閱讀內容時，需重新選取，不會只輸出標題或空的 ZIP。

細項 XML 使用 `ExportScope Version="1"` 標示範圍，現行匯入仍替換所選模組，不能逐項合併。匯入預覽預設不勾選細項替換；含結構祖先或必要依賴時，不允許替換已有資料的目標模組，請使用空白專案。舊版 App 可能忽略此 metadata，交換前請確認接收端支援範圍辨識並保存完整專案副本。ZIP 整包匯入尚未提供。

章節沿用 `ChapterTreeVersion=3` 的任意層遞迴結構與穩定 ID；空資料夾也會保存。匯出目前以 256 層作為明確的資源保護邊界，超出會提示而非截斷。跨平台文件選擇器與大量稿件效能仍需各平台實測；自動化驗證不代表所有原生平台已驗收。

舊格式開啟時會在記憶體中遷移，使用者儲存前不覆寫原檔；再次儲存輸出 `1.22`。較新且不支援的格式會被拒絕。找不到可靠引用目標的舊資料保留原 ID 或文字，不以同名物件自動配對。

### 自動儲存、備份與復原

自動儲存使用已知檔案位置；沒有可用位置時不應以背景另存對話框代替。AutoBackup 另寫備份檔，維持目前專案位置與未儲存狀態，並依設定的總容量整理備份。

在設定中確認備份目錄、容量及可用空間。升級專案格式、批次取代、匯入或模式轉換前，可先另存副本。Undo／Redo 用於目前工作階段；跨啟動復原應使用已保存的專案、備份或 checkpoint。

Android 檔案操作涉及 SAF URI，Apple 平台涉及持久存取授權；開檔與存檔必須沿用平台橋接，不要只把 URI 當桌面路徑。Web 的 Rhodanthe 使用 Dart fallback；本機檔案、FFI 與 P2P 能力不能直接套用到 Web。

資料格式細節見 [專案 XML 規格](../dart_edition/MNPROJ_FILE_STRUCTURE.md)，程式呼叫見 [檔案 API](API.md#3-專案與檔案-api)。

## 4. 搜尋與取代

從工具列搜尋按鈕或 Ribbon「搜尋」頁開啟搜尋列；開啟搜尋時自動切換到專屬 Ribbon 頁面。輸入文字後使用上一個／下一個檢視匹配結果，再選擇單次或全部取代。桌面 App 主畫面亦註冊 `Ctrl+F`；焦點與平台快捷鍵行為以實際介面為準。

六個搜尋選項統一由 Ribbon「搜尋」頁管理，三種工具列模式共用相同狀態。搜尋列的「搜尋選項」按鈕會切換到該頁，不再展開另一組設定；修改選項會立即更新目前結果。搜尋／取代輸入框與結果導航保留在正文旁。

Moderate 的搜尋選項以「✓ 開／× 關」標示目前狀態；Concise 使用 ✓／× 圖示標示。開啟的選項另有底色，正則模式下無法修改的選項也會顯示實際開關狀態。

| 選項 | 說明 |
| --- | --- |
| 大小寫相同 | 開啟時區分 `Hero` 與 `hero` |
| 全字拼寫需相符 | 限制為完整詞邊界；中文與英文字詞不能假定採相同切詞方式 |
| 正則表示式 | 使用 regexp 語法；不要沿用舊指南把 `?`／`*` 當一般萬用字元 |
| 全半形須相符 | 開啟時區分 `１` 與 `1` |
| 略過標點符號 | 一般文字搜尋可忽略標點 |
| 略過空白字元 | 一般文字搜尋可忽略空格、Tab 與換行 |

正則模式固定大小寫與全半形相符，並停用全字拼寫；搜尋文字含全形、中文、標點或空白時也不能使用全字拼寫。略過標點與空白選項僅影響一般文字搜尋。Rust 原生搜尋不支援 look-around 和 backreference。先用簡單文字確認結果，再逐項調整選項。大量取代前先儲存並確認匹配範圍。標記正文的搜尋與讀者匯出使用投影內容，不能把畫面 offset 直接當 raw 語法 offset。

實作來源：[搜尋與取代](../dart_edition/lib/bin/findreplace.dart)、[App 快捷鍵](../dart_edition/lib/main.dart)。

## 5. 角色、地點、物品與 Scene 快照

時間軸 placement 決定 Scene 的位置；各功能頁依目前 Tick 投影該時刻的狀態。快照以 Scene UUID 連結，Tick 用於排序與 placement 遺失時的 fallback。

| 物品模式 | 結構 | 情境 |
| --- | --- | --- |
| 專用 | 一個 Class 與一個獨立 instance | 唯一且需追蹤個別歷史的物品 |
| 半專用 | 一個 Class、多個 instance，可保留聚合數量 | 同類物品中只有部分需個別追蹤 |
| 非專用 | 一個 Class，以分配量記錄歸屬 | 可互換且只需統計數量的物品 |

建立物品後，以物件選擇器連到人物、地點、事件或 Scene。新增快照先選 Scene；同一 Scene 有多個 placement 時可指定來源，未指定時使用固定排序規則。Scene 移動後，快照跟隨新的 Tick；placement 移除後，快照資料仍保留。

人物、地點、物品 Class 與 instance 的微型時間軸可查看、選取及複製支援的快照。對話框內的預覽只改本地選取，確認後才提交。地點每個節點有獨立狀態；父節點不存在時仍可保留子節點樹殼追溯。

故事中的消失以「此時已存在」等狀態記錄。永久刪除會影響引用；模式轉換會先預覽，並保留來源 ID 與歷史資料供追溯。詳見 [物品與 Scene 指南](../dart_edition/ITEMS_AND_SCENE_SNAPSHOTS_GUIDE.md) 與 [微型時間軸](../dart_edition/MINI_TIMELINE.md)。

## 6. 標記與短語

標記把人物、地點、事件、伏筆或計畫的 UUID 與顯示文字保存於正文。畫面呈現投影文字；儲存保留完整 raw 語法，重新命名以 UUID 維持連結。純高亮不要求 UUID。使用介面的標記選單與 formatter 建立內容，避免手動拼接未跳脫的字串。

短語庫保存目前專案內可重複插入的內容、短碼與標籤，支援建立、編輯、複製、停用與刪除。從 Ribbon「常用 → 短語」開啟短語庫、插入短語，或將正文選取內容存為短語；三種工具列模式共用這些指令。輸入 `;;` 查詢，或由 `\`／`/` 的手動選單進入短語分類。接受候選時一次替換 raw 範圍，碰到 Mention 時保留完整原子邊界。貼上與 IME 組字不觸發候選；Esc 保留字面輸入。

跨專案短語的 Mention 必須明確重新連結或轉純文字；刪除短語不會修改已插入的正文。詳見 [標記設計與實作紀錄](../dart_edition/INLINE_ANNOTATION_IMPLEMENTATION_PLAN.md) 和 [短語實作紀錄](../dart_edition/PHRASE_SYSTEM_PLAN.md)。

## 7. Copilot 與 MCP

### Copilot

設定 provider、API URL 與模型後，確認目的 host 再送出請求。API Key 保存在本機安全儲存，可從 Copilot 頁面清除；作品內容直接傳到設定的 provider。

- Chat 傳送對話訊息。
- Ask 傳送目前章節，可另選專案摘要或最多 12 個補充資源；摘要與補充資源是互斥 scope。
- Plan 產生唯讀 JSON 提案並驗證本次 context，沒有自動套用入口。

Ask／Plan 的章節上限為 72 KiB UTF-8，摘要 24 KiB，最多 12 個補充資源，每筆 8 KiB、合計 32 KiB。內容可能截斷；送出前應查看 scope。Ask／Plan 另附 App 內建格式參考；對話與 Plan 不跨 App 啟動保存。自訂雲端 URL 使用 HTTPS，HTTP 僅允許 loopback。

發布操作與平台待驗證項目見 [Copilot 發布手冊](../dart_edition/COPILOT_ASK_PLAN_RELEASE_RUNBOOK.md)。

### MCP

1. 在 App 開啟要授權的專案。
2. 從設定啟用「MCP 唯讀整合」。
3. 使用「複製 MCP Host 設定」，貼到支援 stdio MCP 的 Host。
4. Host 啟動 sidecar 後即可列出工具並讀取授權資料。
5. 停止授權或切換專案後，重新啟用並建立新連線。

授權預設 8 小時到期；一次性 descriptor 在 handshake 後刪除。App 停止授權或生命週期停止整合後，Host 的讀取會失敗。Host 設定只帶 sidecar 與 descriptor 路徑；整合契約見 [MCP API](API.md#2-mcp-唯讀-api)。

## 8. 內網同步、協作與修訂

P2P 裝置必須能經 LAN TCP 互通，依介面選擇作品並完成配對。端點可達不代表已授權讀取作品；摘要、快照與協作交換透過配對後的加密 session。

快照交換驗證 manifest、大小、完整雜湊及專案 XML。資料分歧時使用衝突處理或另存副本。即時協作 schema 為 `8`，XML 格式為 `1.22`；雙方需使用相容版本。多人操作的交易片段收齊後再套用，避免半完成狀態。

### 儀表板與寫作進度

桌面版可從 Ribbon「常用 → 顯示區塊」切換導覽列、側邊欄及儀表板。儀表板位於編輯區右側，可獨立捲動；寬度不足時收合為「開啟儀表板」按鈕，點擊後以對話框查看。

| 儀表 | 數值與操作 |
| --- | --- |
| 每日目標 | 本機所有作品今天的淨增字數／每日目標，初始 1,000 字；輸入增加、刪字扣回，負值保留。 |
| 本章字數 | 目前選取章節字數／本章目標，預設目標 2,000 字；尚未選章節時顯示「—」。 |
| 全書字數 | 作品總字數／全書目標，預設目標 100,000 字，可從「新增儀表」加入。 |
| 更新計畫 | 已標記「已完成」的計畫數／全部計畫數，從計畫規劃更新狀態。 |
| 伏筆回收 | 已標記「已揭露」的伏筆數／全部伏筆數，從計畫規劃維護線索狀態。 |
| 追蹤校訂 | 相對比較基準的變更量；外環為新增，內環為校訂／移除。 |

點擊儀表可查看目前值、目標或總計。字數儀表的「設定字數目標」接受 1 到 999,999,999 的整數；超過目標後進度環最高顯示 100%，實際字數仍會繼續增加。從資訊選單選擇「刪除儀表」可移除顯示，再從底部「新增儀表」恢復；每種儀表最多顯示一次，移除儀表會保留原作品資料。儀表配置屬目前工作區狀態；字數目標則會保存。每章／全文可選「預設」或「僅限本檔案」：預設存在本機，影響所有未覆寫作品；檔案專屬值隨 `.mnproj` 保存。「恢復使用預設」只清除該項覆寫。修改預設不會清除既有覆寫，即使兩者數值相同也保留各自範圍。設定頁「寫作目標」可調整每日及兩項預設。

每日進度以全形字元＋半形單字計算讀者文字，排除標記語法；固定計數方式不受其他字數顯示模式影響。開檔、匯入、備份復原及他人同步不增加成績，本機 Undo／Redo 按實際可計入變化扣回或增加。放棄未保存草稿會抵銷其可計入增量。隱藏每日儀表仍會統計；跨當地午夜自動換日，休眠後回前景也會更新。帳本保存本機所有作品合計，不同步其他裝置；正常關閉前會等待保存，異常終止可能遺失最近尚未落盤的變化。統計無法讀取或保存時，從每日儀表資訊選單重試。

追蹤校訂的兩環顯示各類計數占合計的比例。例如新增 8 筆、校訂 2 筆時，外環為 80%、內環為 20%；這些數值描述變更組成。正文按新增／移除行數統計，設定資料修改一筆會在兩者各計一筆，同一筆的多個欄位不重複計數；只改動文末換行時也各計一筆。計數比較目前內容與基準，並非累計按鍵次數。

從追蹤校訂儀表的選單可開始追蹤、查看比較基準並開啟「查看校訂明細」。桌面版明細位於儀表板左側，可拖曳分隔線調整寬度；窄視窗會覆蓋編輯區右側。定位差異後明細仍保持開啟，完成後按「收合修訂窗格」。移除追蹤儀表只隱藏顯示，追蹤仍會繼續。App 內「儀表板與寫作進度」主題另有逐步操作與常見問題。

修訂追蹤以 detached baseline 比較目前正文與結構化 record；checkpoint 另外保存於本機應用程式支援目錄，並非所有差異都能直接還原。操作前依面板顯示的目標與支援動作確認，細節見 [修訂追蹤模組說明](../dart_edition/lib/features/revision_tracking/README.md)。

若 P2P 探測失敗，依序確認相同網路、正確 Wi-Fi IPv4／Port、對方服務已啟動及防火牆允許連線。版本不符時先各自保存作品再升級。介面與大小限制見 [P2P API](API.md#6-p2p-與即時協作-api)。

## 9. 開發環境與專案結構

目前 `pubspec.yaml` 要求 Dart `^3.12.1`；其中 Flutter Quill 11.6.0 註記要求 Flutter 3.44 以上。實際使用的 SDK 版本應記錄在各次建置證據中。原生 Rhodanthe 另需 Rust／Cargo；工具鏈以 [rust-toolchain.toml](../dart_edition/rust/rust-toolchain.toml) 為準。

```powershell
cd dart_edition
flutter pub get
flutter run
```

儲存庫含 Windows、macOS、Linux、Android、iOS 與 Web 平台目錄；各平台發布仍需該平台的建置與權限驗證，不能把舊 README 的最低 OS 表當成現行驗收保證。

```text
dart_edition/
├── lib/
│   ├── main.dart                 # App 啟動與整合
│   ├── bin/                      # 編輯器、檔案與 App 工具
│   ├── models/                   # 專案模型、codec 與遷移
│   ├── modules/                  # 功能頁面
│   ├── features/                 # Copilot、MCP、story_read、phrases、revision_tracking
│   ├── data/                     # Repository、P2P 與資料層
│   ├── domain/                   # Use case、repository 介面與協作模型
│   ├── infrastructure/rhodanthe/ # Rust FFI、worker 與 render adapter
│   ├── presentation/             # Provider 與共用 view
│   └── ui_library/               # 共用 UI 元件
├── rust/                         # Rhodanthe core、analyzer 與 C ABI
├── assets/                       # 圖示、字型與 JSON
├── test/                         # Flutter 測試
├── benchmark/                    # Rhodanthe 等效能量測
└── tool/                         # 建置、發布與政策檢查
```

狀態管理使用 Riverpod，資料模型使用 Freezed，正文整合 Code Text Field 與 Quill 路徑。作品檔案操作經 use case／repository 接入平台檔案服務；Copilot 與 MCP 共用 story_read 的唯讀 snapshot 與 context budget。

Rhodanthe 已接入 Dart worker 與 editor session；預設 release stage 為 `default-on`，失敗時回到 Dart highlighter。FFI 同步呼叫放在長駐 isolate，render plan 需通過版本、revision、UTF-16 與範圍驗證才發布。

## 10. 驗證、建置與發布

以下命令從 `dart_edition/` 執行：

```powershell
dart format --output=none --set-exit-if-changed lib test tool
dart run tool/check_initstate_provider_assignments.dart
flutter analyze
flutter test
```

修改 Freezed／Riverpod annotation 後重新產生程式碼：

```powershell
dart run build_runner build --delete-conflicting-outputs
```

修改 Rust 後，從 `dart_edition/rust/` 執行：

```powershell
cargo fmt --all --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
```

Windows 範例：

```powershell
flutter build windows --release
dart run tool/build_mcp_sidecar.dart
```

Copilot internal build 需明確傳入 `--dart-define=COPILOT_ASK_ENABLED=true` 和 `--dart-define=COPILOT_PLAN_ENABLED=true`。Rhodanthe 平台封裝與手動升階流程見 [PACKAGING](../dart_edition/rust/PACKAGING.md) 和 [Dart infrastructure](../dart_edition/lib/infrastructure/rhodanthe/README.md)。

| 發布項目 | 專用流程 |
| --- | --- |
| MCP | [Windows gate](../dart_edition/tool/mcp_release_check.ps1)、[macOS／Linux gate](../dart_edition/tool/mcp_release_check.sh)、[驗收紀錄](../dart_edition/MCP_PHASE5_IMPLEMENTATION.md) |
| Copilot | [Windows gate](../dart_edition/tool/copilot_release_check.ps1)、[發布與回滾手冊](../dart_edition/COPILOT_ASK_PLAN_RELEASE_RUNBOOK.md) |
| Quill | [Windows gate](../dart_edition/tool/quill_release_check.ps1)、[遷移契約](../dart_edition/QUILL_PLAIN_TEXT_EDITOR_PHASE0.md) |
| Rhodanthe | [rollout preparation](../dart_edition/tool/prepare_rhodanthe_rollout.dart)、[audit checker](../dart_edition/tool/check_rhodanthe_rollout.dart)、[benchmark](../dart_edition/benchmark/RHODANTHE.md) |

MCP 原始 Phase 5 紀錄仍列有 macOS／Linux 與實際 Host 人工 gate；Copilot 原始發布手冊亦列有其他平台待驗證項目。歷史測試數量與 hash 不作為目前 checkout 的重新驗證結果。

## 11. 文件維護

變更功能時更新本文件的行為與限制；變更參數、版本、預算或錯誤碼時更新 [API 文件](API.md)。深層規格、UI 尺寸／間距規範、保留的設計與發布驗收資料依 [參考文件索引](SOURCES.md) 查閱。已取代的舊指南與重複紀錄已清理，歷史內容可由 Git 查閱；新增文件亦需加入索引。
