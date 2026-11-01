# 匯出功能重寫計畫

日期：2026-11-01。狀態：主要流程與相關自動化驗證完成；原生平台與大量稿件效能尚待實測。全專案仍有角色介面測試失敗，詳見第 9 節。

## 1. 範圍與建議

本次重寫「檔案 → 匯出」，涵蓋正文 TXT／Markdown、局部專案 XML、匯出介面，以及分散成多份文件後打包 ZIP 的功能。章節、大綱、角色、地點與物品均提供可收合 Checkbox 細項選取，並明訂無限層章節的專案資料與 ZIP 存放規範。以用途選擇取代目前單純選格式與模組的介面，統一內容產生、分檔、預覽、封裝、寫檔與結果回報。

使用者確認的範圍為：重整現有 TXT／Markdown／XML 與匯出介面、加入分散文件 ZIP 匯出、預留 Word／PDF 選項。Word 使用 `.docx`，Word／PDF 本次僅建立格式能力描述與介面預留，標示「尚未開放」並停用，不產生假格式檔案；排版與 renderer 實作另列後續工作。EPUB 及詞語、色票、模板等獨立匯出仍列後續擴充。本次規劃不預先選定壓縮或文件產生套件。完整 `.mnproj` 保存仍由既有專案保存流程負責。

優先順序：輸出正確性與結果契約 → 單一匯出核心 → 用途與預覽介面 → 分檔 ZIP → 舊路徑清理。

## 2. 現況與重寫原因

以下為目前工作目錄的靜態程式碼檢查結果，包含尚未提交的變更；未執行平台實測。

本節記錄重寫前的問題；目前實作狀態與差異見第 8 節。

| 問題 | 目前來源與影響 | 重寫要求 |
| --- | --- | --- |
| 取消仍回報成功 | `FileService.exportTextWithResult` 有 bool，但 repository／use case 的 `exportText` 回傳 void，controller 與主畫面因此無法辨識取消 | 寫檔結果一路回傳 UI，取消不顯示成功 |
| 匯出命令過早完成 | `_showExportDialog` 關閉視窗後啟動 `_exportSelective`，未 await；Ribbon 的 Future 可能先結束 | 對話框只回傳選項，呼叫端 await 完整任務 |
| 短語庫選項沒有實際輸出 | 主畫面列出 `Phrases`，但目前 `ProjectIoController.exportSelective` 與 manifest 白名單均漏掉它；舊 `ProjectManager` 路徑另有實作 | 匯入與匯出共用模組描述，補齊短語與 recovery payload |
| 章節順序可能不同於畫面 | `exportAs` 先輸出直接章節，再輸出子資料夾，未使用 `resolvedChildNodeOrder` | 依章節樹的混合排序遍歷 |
| TXT 使用 Markdown 標題 | 同一個 buffer 以 `#` 層級同時輸出 TXT 與 Markdown | 各格式有獨立 renderer |
| 局部 Markdown 定義不明確 | 多數內容是模組 XML 區塊；正文先轉成 reader text，會失去原始註記 | 明確定位為閱讀格式；可再次匯入的資料以 XML 交付 |
| 文件對 Markdown 的保證超過目前程式 | 說明稱含 lossless XML；現行局部匯入直接解析 Project XML，沒有可確認的 Markdown 擷取契約 | 同步修正文件與測試，不承諾現有 Markdown 可以無損往返 |
| 實作分散且已不一致 | controller、`ProjectManager` 及 `_ProjectMerger` 有重複產生邏輯；controller 還依賴多個 view 檔案中的 codec | 共用模型／codec，建立單一內容產生路徑 |
| 章節已有遞迴結構，但缺少完整匯出規範 | `ChapterTreeVersion=3` 支援巢狀與交錯排序；匯出仍有按兩類拆開遍歷的邏輯，codec 也會略過完全沒有文稿的樹 | 規範遞迴裁切、空資料夾、混合排序、深層檔名與舊資料遷移 |
| 細項匯出不能直接等同細項合併匯入 | 現有 importer 以模組替換資料集合；只匯出部分角色／文稿後再次匯入，可能移除同模組其他資料 | 明訂細項 scope metadata 與匯入替換預覽；不得宣稱現有 importer 會逐項合併 |

主要核對來源：[主畫面](../dart_edition/lib/main.dart)、[I/O controller](../dart_edition/lib/presentation/providers/project_io_providers.dart)、[檔案服務與舊流程](../dart_edition/lib/bin/file.dart)、[局部匯入](../dart_edition/lib/application/project_import/selective_project_import.dart)、[章節樹](../dart_edition/lib/models/chapter_selection_data.dart)。

## 3. 使用者流程

沿用 Ribbon 的「匯出」入口，桌面使用寬版對話框，窄視窗改為可捲動的全頁流程；優先沿用現有 AppDialog、表單與回饋元件。

1. **用途**：選「正文交稿」、「設定資料閱讀稿」或「局部專案交換」。預設為正文交稿。
2. **範圍**：正文可選全部、目前文稿或章節樹細項；設定閱讀稿與專案交換先選模組，再展開章節、大綱、角色、地點與物品的 Checkbox 清單逐項選取。其他模組維持整模組選取。
3. **格式與選項**：依用途呈現可用格式；正文可設定是否包含作品資訊、資料夾／章節標題。閱讀用途另顯示停用的 Word（`.docx`）／PDF 選項與「尚未開放」說明。文字格式固定 UTF-8。
4. **檔案組織**：預設「合併為單一文件」，或選「分散文件（ZIP）」。正文按章節拆分，設定閱讀稿與專案交換按模組拆分；內容格式與 ZIP 封裝分開選擇。
5. **預覽**：顯示輸出摘要、文字節錄、缺少關聯的提醒；ZIP 顯示壓縮檔內的檔案樹，可選檔查看節錄。章節、模組與文件數量依實際產物計算，容量依準備好的 bytes 計算，區分文件總大小與 ZIP 大小。
6. **匯出**：選擇檔名與目的位置，等待實際寫入完成，回報成功、取消或錯誤。

| 用途 | 格式 | 內容規則 |
| --- | --- | --- |
| 正文交稿 | `.txt`、`.md` | 按章節樹順序輸出讀者文字；不附內部 XML、註記 UUID、備註或修訂工作階段資料 |
| 設定資料閱讀稿 | `.md` | 選取模組轉成標題、段落、清單或表格；不以 XML code block 代替閱讀內容 |
| 局部專案交換 | `.xml` | 保留所選模組原始資料、UUID、manifest、版本、註記語法與對應快照；沿用既有匯入契約 |

各模組必須明確宣告支援的用途。第一版設定閱讀稿優先覆蓋故事設定、大綱與時間軸、計畫與伏筆、角色、世界、物品與短語；尚未完成 renderer 的組合不開放，避免空檔仍回報成功。

ZIP 是檔案組織選項，沿用上表的內容規則。正文產生多份 TXT 或 Markdown，設定閱讀稿產生各模組 Markdown，專案交換產生各模組 XML；各次匯出使用同一種內容格式。

舊局部 Markdown 的 XML 區塊輸出停止作為新介面選項；已存在的檔案不修改。若需要相容模式，單獨命名為「舊版 XML 區塊 Markdown」，不得標示為無損。真正可匯入的 Markdown 封裝是另一項格式與匯入器工作，需獨立立項。

### 3.1 分散文件 ZIP 規則

- 正文每章一份文件，依原章節樹建立資料夾；資料夾與章節共用同層順序編號，例如 `01_第一卷/01_序章.md`、`01_第一卷/02_插曲/01_夜行.md`。編號遵循混合排序，讓解壓縮後仍可辨識閱讀順序。
- 設定閱讀稿與交換 XML 每個模組一份文件，例如 `01_故事設定.md` 或 `01_BaseInfo.xml`；所選實體相應的快照與 changes 一起保存。XML 每份均有自己的 Project 根節點、版本與僅列出該模組的 manifest；整模組輸出沿用既有匯入語意，細項輸出另遵循 3.4 節的 scope 與替換預覽契約。
- XML 的跨模組關聯提醒同時出現在預覽與 ZIP 說明中；不因分檔而重複自動夾帶其他模組。ZIP 整包匯入不在本次範圍，使用者解壓後依既有流程選取 XML。
- 根目錄附 `README.txt`，說明格式、閱讀順序、註記處理及 XML 匯入方式；另附 `export-manifest.json`（獨立的封裝 schema version、內容格式、檔案相對路徑、順序與來源對應）。閱讀用途的 manifest 僅記錄順序、名稱與路徑，不帶內部 UUID；交換用途才可保留來源識別碼。
- 作品資訊若有勾選，正文 ZIP 額外產生 `00_作品資訊.txt`／`.md`；各章不重複整份作品資訊。空章節保留文件，空資料夾不單獨產生項目。至少須有一份內容文件，只有 README／manifest 不算有效匯出。
- 檔名保留可用的中文，清理路徑分隔符、控制字元、保留名稱與不支援的結尾字元；處理重名、大小寫碰撞、Unicode 正規化及路徑長度。ZIP entry 一律為相對路徑，不含絕對路徑或 `..`。標題原文留在文件內。
- 準備階段使用同一組文件 bytes 建立預覽與 ZIP，封裝完成後才進入可保存的預覽狀態；封裝失敗就不開啟保存流程。平台 Writer 最終只保存一個 `.zip`，MIME 為 `application/zip`。

### 3.2 細項匯出與 Checkbox 規則

五個清單都必須列出來源快照中的全部項目，不沿用編輯頁面目前收合、搜尋或封存篩選造成的隱藏狀態。正文交稿只呈現章節清單；設定閱讀稿與 XML 依選取模組呈現相應清單。

| 清單 | 可收合列與 Checkbox 層級 | 身分與輸出範圍 |
| --- | --- | --- |
| 章節 | 資料夾 → 任意層子資料夾／文稿，可同層交錯 | 資料夾用 `segmentUUID`、文稿用 `chapterUUID`；依來源樹順序呈現 |
| 大綱 | 大箱（故事線）→ 中箱（事件）→ 小箱（場景） | 分別用 `StorylineData.chapterUUID`、`storyEventUUID`、`sceneUUID`；故事線 ID 雖名為 chapterUUID，與正文文稿 ID 分開命名空間 |
| 角色 | 可收合的「全部角色」群組 → 所有角色；每位角色亦可展開查看摘要 | 用 `characterId`；本次選取粒度為整位角色，展開摘要不新增欄位級勾選，也不虛構角色父子關係 |
| 地點 | 依世界設定的實際 `child` 樹列出地點與子地點 | 用 `LocationData.id`；混合世界節點顯示類型，不因非地點祖先而丟失其下地點；世界模組的其他節點仍可辨識並選取 |
| 物品 | 分類 → 物品定義 → 實例 | 分類為 UI 群組，定義用 `classId`，實例用 `instanceId`；未分類設獨立群組，封存項目標示狀態仍可選，不新增原資料沒有的遞迴父子關係 |

共同互動規則：

1. 展開箭頭與 Checkbox 各自操作。收合只改顯示，保留勾選；每列顯示名稱、類型與已選／可選數量。
2. 父列採全選／未選／部分選取三態。勾選父列選入自身可匯出資料與全部後代；取消父列清除該子樹。部分選取時再按 Checkbox 為全選，第二次為清除。
3. 有自身資料的父節點（大箱、中箱、地點、物品定義）提供「僅此項」選取；其三態包含自身與子項。結構資料夾與純分類群組只代表子樹，沒有虛構正文資料。角色本身為單一可選項，其摘要展開不影響勾選。
4. 提供「全選／清除／全部展開／全部收合」與名稱搜尋。搜尋僅改可見範圍並保留祖先路徑，不改選取；「全選」明示作用於整個清單，若提供搜尋結果批次選取，另標示「選取搜尋結果」。
5. 同名項目以穩定 ID 區分；內部 key 包含模組及節點類型，不能用名稱、畫面 index 或檔名判斷身分。清單與輸出共用同一份快照與排序。
6. 只選子項時保留祖先作為結構路徑，但不等於選入祖先全部內容或兄弟項目。預覽以不同標示區分「使用者選取」、「必要結構」與「必要依賴」。大綱／地點 XML 的祖先只保留識別、名稱、類型等必要結構欄位，不夾帶未選祖先的備註或其他資料。
7. 角色只包含所選角色的 states／baselines／changes；地點、物品只包含相應 ID 的快照與 changes。物品實例必須附其 class 定義作為必要依賴，預覽明列；不連帶選入同 class 其他實例。
8. 關聯資料按選取範圍裁切：時間軸保留選取場景的 placements、必要 tracks 與選取端點相關的章節連結；不得夾帶未選場景。角色／物品／地點的外部參照保留原 ID 並列出缺少目標，不能藉參照自動帶入整個外部實體。閱讀稿只顯示相應可讀標籤，無法解析時顯示未解析參照提示。
9. 大箱、中箱與地點的祖先結構，以及實例必要 class，必須在 scope metadata 分清「完整內容」與「結構／依賴」，以便後續匯入預覽判斷，不能把未附資料解讀為刪除。
10. 切換單檔／ZIP 保留細項選取；切換用途時保留相容模組的 ID 集合，不把隱藏且不適用的選項送入 request。大量項目採可視列渲染，深層縮排有上限但仍顯示完整路徑與實際深度。

細項 scope 不可只依 `selectedModules` 推定。未啟用細項模式代表整個模組；啟用後的空集合代表沒有選取內容，不得退回全模組。UI 要求至少一個可輸出的項目；交換用途可明確選取空資料夾，但空集合不等於空資料夾。

### 3.3 無限層章節的新存放規範

**邏輯樹與專案 XML**

- 沿用已存在的 `ChapterTreeVersion=3`。隱藏根節點 `chapter-tree-root` 只是執行時容器，不輸出為使用者資料夾，也不納入 ZIP 路徑；目前根下仍存放 Segment 資料夾，不另開放根下直接文稿。
- `SegmentData` 以 `chapters`、`childSegments` 與 `childNodeOrder` 表達直接子項；XML 以遞迴 `<Segment>`／`<Chapter>` 的實際排列存放同層混合順序。不能把 descendant 全部攤平成第一層，也不能另以先文稿、後資料夾的方式改變順序。
- 資料夾與文稿 ID 穩定且在章節樹內唯一；同名合法。移動／改名不重生 ID，匯出不改 ID。每個節點只有一個父節點；循環與重複身分須在準備階段攔截，不產生含糊的樹。
- 整樹保存保留所有資料夾，包含完全空的資料夾；局部 XML 保留選取資料夾、選取後代及必要祖先。需調整 codec 目前「沒有任何文稿就不輸出」的條件，並確認 loader 能區分缺少 ChapterSelection、明確空樹與僅有空資料夾。
- 只選深層文稿時，逐層保留原祖先鏈，只裁掉未選兄弟；裁切後 `childNodeOrder` 保留原相對順序且不含已刪項目，不能重新建立 UUID 或插入預設 Folder 1／Chapter 1。
- 舊兩層資料視為根下資料夾加其文稿直接升級，保留名稱、ID、內容與順序。v0／v1／v2 缺少混合排序時沿用既有「直接文稿在前、子資料夾在後」回退；v3 開始以來源混合順序為準，不因重寫匯出而自行調換。
- 「無限層」表示資料模型沒有固定兩層或其他業務深度上限，不表示接受無限資源；匯出遍歷、範圍解析與深度檢查需使用可處理深樹的策略，避免 call stack overflow。既有 reader／writer 若保留遞迴，須量測並加明確、可回報的資源邊界，不可靜默截斷資料。

以下為裁切後仍保留祖先的結構示意；正式 UUID 沿用來源值：

```xml
<Type ChapterTreeVersion="3">
  <Name>ChapterSelection</Name>
  <Segment Name="第一卷" UUID="原卷ID">
    <Segment Name="第一部" UUID="原部ID">
      <Segment Name="插曲" UUID="原插曲ID">
        <Chapter Name="夜行" UUID="原文稿ID">
          <Content>所選文稿原始正文</Content>
        </Chapter>
      </Segment>
    </Segment>
  </Segment>
</Type>
```

**單檔與 ZIP 實體存放**

- 單一 TXT／Markdown 以原樹深度優先混合順序產生內容。Markdown 標題最多六級，超過部分改以完整路徑段落或 breadcrumb 呈現，不產生七級以上的無效標題；TXT 使用路徑與分隔線。XML 保留完整遞迴結構。
- 正文分檔維持「一篇文稿一檔」，ZIP 目錄映射原資料夾階層；不把資料夾正文與文稿混為一種節點。每層資料夾與文稿依完整來源同層排序共同編號，至少兩位，超過 99 項自動增寬；細項裁切保留來源序號，允許跳號。
- `export-manifest.json` 保存輸出順序、原邏輯祖先名稱鏈、實際 entry 路徑，以及正常／替代路徑模式。交換用途另存原節點與祖先 ID；閱讀用途只存名稱鏈與匯出內部序號，不洩漏專案內部 ID。
- 不把作業系統路徑長度當成章節深度限制。準備階段依目標平台與採用的 ZIP 工具設定保守的 entry 長度、路徑元件長度及總深度預算；超出時該次正文 ZIP 統一改用短路徑模式，如 `documents/000001_夜行.md`，以 manifest 與 README 保留完整邏輯路徑與閱讀順序。預覽明示替代後的路徑，不刪除章節或祖先資訊。
- 檔名清理及截短後，以來源順序／匯出序號穩定解決重名，避免用專案 UUID 作閱讀檔名。檔案樹預覽可同時顯示邏輯樹與實際 ZIP entry，完整父子關係不依賴可變檔名還原。
- 選取的空資料夾在 XML 與 manifest 明確保留；正文 ZIP 沒有內容文件時回到範圍選取提示，不用空資料夾製造成功結果。若既有「XML 按模組一檔」模式匯出章節，全部所選章節仍存同一份 ChapterSelection XML，與正文按文稿分檔的用途區分。

### 3.4 細項 XML 與再次匯入

細項選取新增的是「模組內的子集合」，現有 `SelectiveProjectImporter` 的行為仍是模組替換。不能把含部分角色或部分章節的 XML 稱為可安全逐項合併。

- 為細項交換新增具獨立版本的 scope metadata：整模組／細項模式、各類已選 ID、結構祖先、必要依賴與未解析參照。具體 XML 欄位在實作階段與 importer 一起定稿；不混用 `ChapterTreeVersion` 表示細項選取版本。
- 新版匯入預覽辨識細項 scope，明示將替換的目標模組與可能移除的未附項目，預設不勾選這些替換動作，需使用者明確選取並確認。結構祖先／依賴不代表其空欄位可覆寫目標實體；無法正確保留者阻止該次匯入。
- 若要提供「依 ID 合併細項」而保留目標未選資料，另需定義欄位覆寫、祖先位置與排序衝突等契約；本次不把它假設成已存在的匯入能力。XML 仍可在空白專案驗證結構與選取內容往返。
- 舊版 App 不理解新增 scope，無法保證會阻止整模組替換。輸出摘要與 ZIP README 明列最低可辨識的 App／scope 版本及舊版限制；若需調升專案格式版本，連同遷移與版本檢查一起處理，不能只增加 metadata 就宣稱所有舊版相容。

## 4. 核心設計

```text
ExportDialog → ExportRequest
                     ↓
同步目前編輯內容 → 快照＋專案 session／revision
                     ↓
ExportService：驗證 → 範圍解析 → renderer → ExportDocument 集合
                     ↓
ExportPackager：單一文件／ZIP → PreparedExport
                     ↓
同一份 PreparedExport → 預覽 → ExportWriter → ExportResult
```

### 4.1 契約

以下名稱為建議介面，不是現有 API。

- `ExportRequest`：用途、內容格式、檔案組織（`singleFile`／`splitZip`）、模組集合、各模組的整體／細項模式及型別化 ID 集合、標題等選項。包含資料夾／文稿、大箱／中箱／小箱、角色、地點、物品定義／實例 ID，不能只存共用字串集合。拆分粒度依用途固定為章節或模組，避免無效組合。
- `ExportSelectionNode`／`ExportSelectionState`：各模組 adapter 產生節點類型、來源 ID、名稱、排序、子項與自身是否有內容；共用元件處理三態、展開與搜尋。選取狀態與展開狀態分離。
- `ResolvedExportScope`：從 request 與快照求得實際內容節點、結構祖先、必要依賴、缺少參照與輸出順序；renderer 與 ZIP 共用，避免各自裁切。scope metadata 以此結果產生。
- `ExportFormatCapability`：格式 ID、副檔名、MIME、適用用途、支援的檔案組織、可用狀態與停用說明。預留 `docx`／`pdf`，service 也會拒絕尚未開放的格式，不能只依賴 UI 停用。
- `ExportContext`：同步編輯器後擷取的專案快照、來源 session、revision、建議檔名。任務只讀取這份快照。
- `ExportDocument`：一份內容文件的相對路徑、順序、格式、bytes、預覽資料與來源對應；內部來源識別資料不直接等同於對外 manifest 欄位。
- `ExportPackager`：把文件集合封裝為單一輸出或 ZIP，集中處理 entry 命名、README 與 manifest；renderer 不處理壓縮，Writer 不處理分檔。
- `PreparedExport`：可直接寫出的 bytes、MIME、建議副檔名、文件清單、內容摘要與 warnings。預覽與最終檔案來自同一份產物；大型 ZIP 可改以受控暫存檔承載，避免文件與壓縮 bytes 同時常駐記憶體。
- `ExportResult`：`saved`（可用時含目的位置）、`cancelled`、`failed`（型別化錯誤）。過期的 session 結果與真正取消分開處理；磁碟已寫入不得改稱取消。
- `ExportTaskState`：`idle → preparing → packaging → ready → choosingDestination → writing → completed/cancelled/failed`；單檔可略過 packaging。避免與自動儲存共用單一狀態而互相覆蓋。

UI 只處理選項與結果回饋；ExportService 不依賴 BuildContext、view 或檔案選擇器。Writer 只負責保存產物，不再自行重新格式化 Markdown。

### 4.2 建議檔案分工

```text
lib/application/project_export/
  export_models.dart
  export_service.dart
  export_scope_resolver.dart
  export_selection_models.dart
  selection_adapters/chapter_selection_adapter.dart
  selection_adapters/outline_selection_adapter.dart
  selection_adapters/character_selection_adapter.dart
  selection_adapters/location_selection_adapter.dart
  selection_adapters/item_selection_adapter.dart
  export_format_capabilities.dart
  export_document_naming.dart
  packaging/export_packager.dart
  packaging/zip_export_packager.dart
  renderers/plain_text_renderer.dart
  renderers/markdown_renderer.dart
  renderers/selective_xml_renderer.dart
lib/domain/repositories/export_writer.dart
lib/data/repositories/platform_export_writer.dart
lib/presentation/providers/project_export_providers.dart
lib/presentation/widgets/project_export/export_dialog.dart
lib/presentation/widgets/project_export/export_selection_tree.dart
```

匯入匯出共用的 `ProjectModule`／模組描述放在中立模型層；保留既有 `SelectiveProjectModule` 相容轉接，再逐步移除。模組描述包含 ID、名稱、所屬 XML types、支援用途與關聯需求，避免 UI、manifest、renderer 各維護一份名單。

XML renderer 重用既有 codec；必要時把 codec 從 view 移到 models/codecs，view 先保留 re-export。這次只移動匯出所需部分，不順帶重寫所有模組。

### 4.3 內容正確性

- 章節範圍以 UUID 定位，沿 `resolvedChildNodeOrder` 遞迴；可借用 `ChapterTree` 的查找與遍歷。父資料夾與子章節重複勾選時只輸出一次，順序以原樹為準。
- TXT 與 Markdown 分開處理標題。Markdown 對自動產生的標題／欄位文字做適當 escaping；正文預設視為純文字，保留換行並避免 `#`、反引號等被意外解讀為格式。
- 正文沿用 `InlineAnnotationProjection.readerTextFromRaw`，不自行用正則去除標記；交換 XML 保留 raw。補測各種註記、跳脫及不完整語法，明確記錄既有投影行為。
- 模組交換保留所選實體相應的快照與 changes，例如所選角色的 states／baselines／changes；不把同模組所有實體快照都帶出。局部選取造成跨模組缺少參照時，預覽列出缺少項目，由使用者明確加選或保留局部範圍。物品實例的 class 定義屬必要依賴，明列於預覽，規則依 3.2 節。
- `Phrases` 同時涵蓋正常短語與 `phrasesRecoveryPayload`，維持現有 codec 的復原規則。含 Mention 的短語跨專案使用可能缺少目標，需在交換摘要提醒。
- 空模組仍可出現在交換 manifest，以保留既有局部匯入的「明確選取空集合」語意；若再次匯入可能清空目標模組，摘要須明說。閱讀用途沒有內容時顯示空狀態，不假裝產生有效交稿內容。
- 局部交換不宣稱是完整備份。修訂工作階段與其他未選模組不自動打包；完整保存使用 `.mnproj`。
- 匯出不更新最近儲存時間、不變更 project UUID、不清除 dirty、不寫入修訂或同步狀態。

### 4.4 非同步與平台寫入

- 對話框回傳 `ExportRequest?`，主畫面 await 準備、預覽與寫入，讓 Ribbon busy 狀態涵蓋整段任務；防止同一匯出任務重複執行。
- 建立預覽前先 flush 編輯器並擷取快照；預覽開啟後如來源內容已變更，明示快照版本並提供重新產生。切換專案後、寫入開始前使舊任務失效；寫入已開始則讓它完成，結果歸屬原任務，不更新新專案狀態。
- 沿用 `ProjectIoSessionCoordinator` 的 token／generation 概念；快照準備可配合既有序列化規則，但不把等待匯出選擇器整段塞進自動儲存佇列。
- 桌面 Writer 維持選位置後由應用程式寫入；可支援的本機路徑採同目錄暫存檔與安全替換，失敗清理暫存並保留原檔。替換語意需按平台驗證。
- Android／iOS 沿用 bytes／系統文件選擇器流程，成功標準為實際保存呼叫完成；不假設回傳字串一定是可直接寫入或開啟的檔案路徑。
- 副檔名、檔名清理、覆寫確認與文字編碼由共用規則處理；取消不顯示成功，失敗提供可重試的原因。只在平台與目的位置允許時顯示「開啟位置」。
- 大稿件先記錄準備時間與記憶體成本；預覽限制渲染節錄。若量測顯示主執行緒阻塞，再將投影與 renderer 移到 isolate，並核對快照可傳輸性。進度先顯示工作階段，不提供虛構百分比。

## 5. 分階段實作與驗收

| 階段 | 可獨立交付的工作 | 完成條件 |
| --- | --- | --- |
| 1：建立基準並修正結果 | 補目前輸出 fixtures；新增匯出結果契約與 adapter；修正取消假成功、Future 未等待、短語遺漏與章節排序 | 既有入口仍可用；能區分成功／取消／失敗；真實排序與 Phrases／recovery 有回歸測試 |
| 2：抽出匯出核心與範圍裁切 | 引入 request、五種 selection adapter、ResolvedExportScope、renderer、Writer；用共用模組描述取代字串清單；規範遞迴章節與細項 scope | 不透過 Widget 即可驗證選取、祖先與依賴；不夾帶未選兄弟或快照；整模組 XML 維持既有語意，細項 XML 能解析且含版本化 scope |
| 3：重做介面與閱讀格式 | 用途、五種可收合 Checkbox 清單、搜尋與三態、選項、預覽與狀態；新增設定閱讀稿 renderer；停用舊混合 Markdown 選項；預留 Word／PDF | 全選／部分選取／僅此項與收合均正確；窄／寬視窗、鍵盤、無障礙可用；預覽與保存內容相同；未開放格式在 UI 與 service 均不可執行 |
| 4：加入分散文件 ZIP | 章節／模組分檔、遞迴目錄與過長路徑替代、README／manifest、封裝器與檔案樹預覽 | 解壓後逐檔內容與預覽一致；任意邏輯深度可由目錄或 manifest 表達；順序正確且無重名覆寫；桌面與行動平台均保存單一 ZIP |
| 5：細項交換相容性 | 細項 scope 的版本／匯入辨識、模組替換預覽與明確確認；驗證必要祖先／依賴不意外覆寫；空樹與空資料夾語意 | 細項資料可在空白專案往返；現有專案替換前明列影響，無法正確處理時阻止；標示舊版 importer 限制 |
| 6：收尾與平台驗收 | 遷移所有正文／局部匯出入口；確認舊呼叫後移除重複邏輯；更新說明／API／測試 | 舊路徑無剩餘呼叫；目標平台的單檔／ZIP 保存、取消、覆寫、錯誤皆有證據；明確標示尚未實測平台 |

第一個實作批次以階段 1 為界；不先一次改完 main、所有 codec、UI 與平台服務，方便逐批檢查行為。

階段順序為開發切分，不代表每階段都單獨對外開放。細項閱讀匯出可先驗收；細項 XML 選項需待階段 5 的 scope／匯入影響處理完成後才開放。

## 6. 驗證計畫

1. **內容與細項裁切**：巢狀／混合章節順序、各類選取去重、單獨小箱／深層地點的祖先裁切、角色專屬快照、物品實例的 class 依賴、未選兄弟不夾帶、型別 ID 不碰撞、無效／消失 ID。涵蓋深層標題、Unicode／emoji／換行、Markdown 特殊字元、空內容。
2. **交換往返測試**：選定模組輸出 XML → 既有 parser → 局部 importer，比較所選資料；涵蓋原始註記、全部快照、短語與 recovery、空模組、缺少跨模組關聯。不只比對輸出含有某個字串。
3. **任務測試**：取消目的位置、寫入例外、重複點擊、期間繼續編輯／切換專案、自動儲存並行；舊任務不得修改目前專案狀態。
4. **無副作用測試**：匯出前後的 UUID、最近儲存時間、dirty、修訂資料一致；預覽只讀。
5. **UI 與平台**：五種清單列出全部來源項目，驗證父子三態、僅此項、收合不取消、搜尋不變更選取、全選作用範圍、同名／未分類／封存項目、必要依賴標示與深層可視列渲染。另驗證用途與格式連動、禁止無效範圍、真實 busy／結果、鍵盤與窄視窗；Windows／macOS／Linux 驗證本機保存，Android／iOS 驗證文件選擇器 bytes 路徑。Web 不因這次重構而宣稱已支援。
6. **ZIP 驗證**：解壓後逐檔比對 renderer bytes 與 manifest，核對章節／模組拆分、混合排序、Unicode 路徑、重名與大小寫碰撞、保留名稱、深層長路徑、空章節及零份內容；核對相對路徑限制與閱讀 manifest 不包含內部 UUID。模擬封裝失敗、保存失敗與取消，確認暫存清理及不誤報成功。
7. **格式預留**：Word／PDF 顯示「尚未開放」，鍵盤與直接 service 呼叫均不能啟動；切換用途或檔案組織不殘留無效選項。
8. **效能量測**：使用具代表性長篇 fixture，記錄字元數、章節數、巢狀深度、平台、準備與封裝耗時、ZIP 大小與記憶體；由基準訂定可接受門檻。涵蓋大量小檔及單一長章節，確認是否需串流壓縮／暫存檔。
9. **章節存放與遷移**：兩層舊檔升級、v2／v3 排序差異、僅空資料夾、空樹／缺少模組區分、混合子項 XML 往返、超過六層標題、深樹無 call stack overflow、長路徑短模式、相同 ID 的重複節點與循環攔截；來源 ID、內容、祖先與順序均不變。
10. **細項 XML 匯入影響**：驗證 scope 版本辨識、預設不勾選替換、明確列出目標未附項目與替換影響、結構／依賴不意外覆寫、舊版格式提醒及無法安全處理時中止。不能只在空白專案測通就宣稱可與既有專案合併。

既有回歸入口：[project_io_status_test.dart](../dart_edition/test/providers/project_io_status_test.dart)、[selective_project_import_test.dart](../dart_edition/test/selective_project_import_test.dart)。實作時保留既有意圖並拆分新的 export service／writer／widget 測試。

每批執行受影響檔案的 analyze 與相關測試，最後執行完整 Flutter analyze／test。更新內建說明時另執行 help 與 help editor integration 測試。

## 7. 文件與後續擴充

實作完成時同步更新 [GUIDE.md](GUIDE.md)、[API.md](API.md)、[內建說明](../dart_edition/assets/help/zh_TW.json) 與 [專案格式文件](../dart_edition/MNPROJ_FILE_STRUCTURE.md)。章節遞迴與混合排序沿用 `ChapterTreeVersion=3`；新增細項 scope／封裝 manifest 各自有版本契約，實作定稿時評估是否需調升專案格式版本，並同步處理遷移與協作相容性。未實作前不把本計畫的新規範寫成主文件中已支援的行為。

分檔 ZIP 為本次必要交付。Word（DOCX）／PDF 在本次完成格式能力描述、介面預留與不支援結果；實際 renderer、中文字型、分頁、目錄、頁首頁尾、授權及平台交付另行規劃，完成後接入同一組 ExportDocument／Packager／Writer 契約。這兩種格式未開放前，不顯示可用的排版設定，也不承諾可採用 ZIP 拆分。

EPUB、匯出預設集、進階排版、ZIP 整包匯入與其他獨立模組匯出列為後續評估。

## 8. 目前實作狀態

- 已接入主匯出入口：正文 TXT／Markdown、設定閱讀稿 Markdown、局部 XML、單檔／ZIP、五種可收合細項 Checkbox 清單、三態與搜尋、角色摘要、預覽與保存結果。Word／PDF 選項維持停用。
- 內容產生與範圍裁切集中於 `application/project_export`，平台保存由 ExportWriter 負責；主畫面 await 完整流程，內容與封裝在 isolate 準備。舊 ProjectManager 的重複匯出 helper 與 Markdown 產生器已移除。
- 章節保存保留遞迴資料夾、空資料夾與明確空樹；ZIP 依來源混合順序編號，超過路徑／深度預算時用短路徑與 manifest。匯出資源保護目前為 256 層，超出明確拒絕而不截斷。
- 細項 XML 具 ExportScope v1；匯入預設不選取細項替換，列出前後項目數。含結構祖先／必要依賴時，禁止替換已有內容的模組；尚未實作依 ID 合併。
- 目前 renderer／packager 集中在 `export_service.dart`，五種 adapter 集中在 `export_selection.dart`，未依上方建議目錄拆成大量小檔。保存結果採 saved／cancelled，失敗以例外交由 UI 回報。
- 原生文件選擇器的 Android／iOS／Windows／Linux 實機驗收與長篇稿件效能量測尚未完成；現有單元／Widget 測試與本機檔案測試不能取代它們。大型 ZIP 目前仍使用記憶體封裝，串流與受控暫存承載列為後續效能工作。
- 模組父列取消會清除子項；清除最後一個子項也會將模組移出匯出範圍。閱讀稿略過無內容模組並提示，全無內容時拒絕輸出，避免只有標題的文件或空 ZIP。

## 9. 驗證結果（2026-11-01）

| 檢查 | 結果 |
| --- | --- |
| 匯出、局部匯入、I/O 狀態、章節樹、說明及大綱切換，共八份測試檔 | 89 個測試通過 |
| 最後一批選取連動修正後的 `project_export_widget_test.dart` | 7 個測試另行重跑，全數通過 |
| 新匯出模組、Writer、匯入範圍與新增測試的 `dart analyze` | No issues found |
| `git diff --check` | 通過 |

完整 Flutter 測試曾執行，該次快照為 1249 通過、4 略過、8 失敗。大綱切換案例使用舊 ListTile 定位，已改為穩定 key 並於上述相關測試中通過；其餘七個角色介面案例獨立重跑仍可重現，未修改本次範圍外的角色功能來掩蓋失敗。

剩餘案例位於 `phase4_phase5_guardrails_test.dart`（角色改名、自訂欄位、刪除關係、人物選單、組織選單）、`character_relationship_layers_test.dart`（可編輯欄位）與 `character_collaboration_selection_test.dart`（協作選取）。這些結果不代表全專案測試已全部通過，也不代表已完成各原生平台驗收。
