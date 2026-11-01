# 三語文案與術語草案

更新日期：2026-11-01  
適用語言：繁體中文、英文、日文。狀態：盤點用草案，英文／日文尚待人工審校，未寫入 App。

## 1. 共用操作

| 語意 | 繁中基準 | 英文草案 | 日文草案 | 建議 key／使用限制 |
| --- | --- | --- | --- | --- |
| 取消動作 | 取消 | Cancel | キャンセル | `commonCancel` |
| 確認選擇 | 確定 | Confirm | 確定 | `commonConfirm`；完成編輯用「完成」，不可與 Quill 的 Ok 自動合併 |
| 完成編輯 | 完成 | Done | 完了 | `commonDone` |
| 關閉面板 | 關閉 | Close | 閉じる | `commonClose`；退出 App 另用 Exit／終了 |
| 儲存文件 | 儲存 | Save | 保存 | `commonSave` |
| 另存新檔 | 另存新檔 | Save As | 名前を付けて保存 | `projectSaveAs` |
| 開啟專案 | 開啟專案 | Open Project | プロジェクトを開く | `projectOpen`；一般開啟連結須獨立 key |
| 建立資料 | 建立 | Create | 作成 | `commonCreate` |
| 新增項目 | 新增 | Add | 追加 | `commonAdd`；「新增角色」須可獨立翻譯，不以字串串接 |
| 刪除項目 | 刪除 | Delete | 削除 | `commonDelete` |
| 移除關聯 | 移除 | Remove | 解除 | 解除關聯與刪除實體分開；集合移除可用日文「削除」 |
| 重試 | 重試 | Retry | 再試行 | `commonRetry` |
| 複製文字 | 複製 | Copy | コピー | `commonCopy`；複製快照另用 Duplicate Snapshot／スナップショットを複製 |
| 重新命名 | 重新命名 | Rename | 名前を変更 | `commonRename` |
| 未命名顯示 | 未命名 | Untitled | 無題 | `commonUntitled`；既有作品名稱與匯出檔名不批次改寫 |
| 復原編輯 | 復原 | Undo | 元に戻す | `editorUndo`；現有 Ribbon `undo` 命令的意義 |
| 重做編輯 | 重做 | Redo | やり直す | `editorRedo` |
| 從備份還原 | 從備份還原 | Restore from Backup | バックアップから復元 | `projectRestoreBackup`；與 Undo 分開 |
| 搜尋／尋找 | 搜尋／尋找 | Search / Find | 検索 | 說明中心 Search、正文 Find，各自保留語境 |
| 取代 | 取代 | Replace | 置換 | `editorReplace` |
| 選取全部 | 全選 | Select All | すべて選択 | 與篩選器的「全部」分開 |

## 2. 模組與寫作術語

| 語意 | 繁中基準 | 英文草案 | 日文草案 | 語境 |
| --- | --- | --- | --- | --- |
| App 首頁 | 首頁 | Home | ホーム | 導覽 |
| Project | 專案 | Project | プロジェクト | `.mnproj` 資料容器 |
| Work | 作品 | Work | 作品 | 使用者的創作；不與專案完全等同 |
| Story information | 故事設定 | Story Settings | 作品設定 | 基本作品資訊頁 |
| Chapter selection | 章節選擇 | Chapters | 章節一覧 | 導覽短標籤 |
| Chapter | 章節 | Chapter | 章 | 作品結構節點；是否包含節需依功能語境 |
| Manuscript | 文稿 | Manuscript | 原稿 | 實際承載正文的項目 |
| Body editor | 正文編輯 | Manuscript Editor | 本文編集 | 不使用程式設計語境的 Body |
| Outline | 大綱 | Outline | アウトライン | 導覽「大綱調整」可另譯 Edit Outline |
| Scene | 場景 | Scene | シーン | Scene 模型，不等於 Location |
| Location | 地點 | Location | 場所 | 世界設定的地點 |
| Timeline | 時間軸 | Timeline | タイムライン | 主時間軸 |
| Mini timeline | 微型時間軸 | Mini Timeline | ミニタイムライン | 預覽元件 |
| Character | 角色 | Character | キャラクター | 角色資料；計數中的 character 指字元 |
| Relationships | 角色關係 | Character Relationships | キャラクター相関 | 關係圖與人物關係表 |
| Worldbuilding | 世界設定 | Worldbuilding | 世界観設定 | 世界架構 |
| Item | 物品 | Item | アイテム | 故事物品，不與一般清單項目共用 key |
| Item class | 物品定義 | Item Definition | アイテム定義 | 內部 Class 保持原鍵；UI 避免誤譯成程式類別 |
| Item instance | 物品實例 | Item Instance | 個別アイテム | 與共用物品定義區分 |
| Plans | 計畫規劃 | Planning | 計画 | 創作計畫模組 |
| Glossary/reference | 詞語參考 | Word Reference | 表現辞典 | 內建詞彙素材，不是翻譯術語表本身 |
| Palette | 文字色票 | Text Palettes | テキストパレット | 文字顏色素材 |
| Proofreading | 文本校正 | Proofreading | 文章校正 | 偵測贅詞等校正功能 |
| Revision tracking | 修訂追蹤 | Track Changes | 変更履歴 | 比較基準及接受／拒絕修訂 |
| Revision | 修訂 | Change | 変更 | UI 中的個別修改；版本協定的 revision ID 不翻譯 |
| Baseline | 比較基準 | Comparison Baseline | 比較基準 | 修訂比較來源 |
| Accept change | 接受修訂 | Accept Change | 変更を反映 | 「取消接受」不是拒絕 |
| Reject change | 拒絕修訂 | Reject Change | 変更を元に戻す | 實際動作須與功能維護者確認 |
| Snapshot | 快照 | Snapshot | スナップショット | Scene／狀態快照；不直接譯成 Backup |
| Backup | 備份 | Backup | バックアップ | 檔案安全副本 |
| Auto save | 自動儲存 | Auto Save | 自動保存 | 寫回目前專案 |
| Auto backup | 自動備份 | Automatic Backup | 自動バックアップ | 建立可復原副本 |
| Sync | 同步 | Sync | 同期 | 跨裝置交換 |
| Collaboration | 協作 | Collaboration | 共同編集 | 即時共同編輯 |
| Conflict | 衝突 | Conflict | 競合 | 合併衝突；衝突 identity 不翻譯 |
| Phrase library | 短語庫 | Phrase Library | フレーズ集 | 使用者可編輯內容 |
| Annotation | 註記 | Annotation | 注釈 | 正文註記 |
| Alias | 別名 | Alias | 別名 | Mention 對應；使用者實際別名不翻譯 |
| Writing goals | 寫作目標 | Writing Goals | 執筆目標 | 每日、每章、全文目標 |
| Daily goal | 每日目標 | Daily Goal | 1日の目標 | 裝置每日進度 |
| Chapter goal | 每章目標 | Chapter Goal | 章ごとの目標 | 可被專案覆寫 |
| Total goal | 全文目標 | Total Goal | 全体の目標 | 全作品範圍 |
| Import / Export | 匯入／匯出 | Import / Export | インポート／エクスポート | 資料交換 |
| Settings / Help / About | 設定／說明／關於 | Settings / Help / About | 設定／ヘルプ／バージョン情報 | 三個獨立導覽 key |
| Protagonist ／ Supporting Character / Antagonist | 主角/配角/反派 | Protagonist ／ Supporting Character / Antagonist | 主人公／脇役／敵役 | 依照細分情況微調 |

## 3. 計數、品牌與待決事項

- 中文「字數」不能一律翻成 Word Count。`characters` 模式為 Character Count／文字数（grapheme clusters）；`wordsAndCharacters` 模式需說明全形字元與半形單字混合規則，建議 Word/Character Count／文字・単語数。既有演算法不因 UI 語言變更。
- UI 中儲存動作統一用「儲存」；現有「保存」若指相同動作可在翻譯遷移時整理，但已儲存內容、原始引用與協定文字維持原樣。
- 「還原備份」「復原編輯」「拒絕修訂」需要三個語意不同的 key，即使某語言恰好使用近似詞。
- `Monogatari Assistant`、`MonoAshi`、`Mosaic`、`Rhodanthe`、`Copilot`、`MCP`、`P2P` 保留名稱；品牌在不同原生平台出現的現況不代表已定案的對外名稱。
    - 但在日文版中例外，`Monogatari Assistant`可對應至`物語アシスタント`、`MonoAshi`可對應至`ものアシ`、`Mosaic`可對應至`モザイク`、`Rhodanthe`可對應至`ローダンセ`。
- `Mention` 先保留功能名稱，首次出現可加本地化用途說明；是否改成「參照／参照」須由產品定名後全案統一。
- 角色類型來源值（主角、重要配角、次要配角、主要反派、次要反派、其他）是既有資料值。
    - 升級資料模型，從1.22版開始使用英文作為資料值。
- 英文／日文審校者、Scene 與場景快照的最終日文名稱、作品容器與章節結構的稱呼仍待指派／確認；此表不是已核准的翻譯資源。

## 4. 使用方式與來源

先讀[文案盤點報告](I18N_COPY_INVENTORY.md)，依語境建立 ARB key，再套用本表；不要依相同原文自動合併所有 key。來源是目前 [導覽](../dart_edition/lib/features/navigation/app_module.dart)、[Ribbon 命令](../dart_edition/lib/bin/appbar.dart)、[修訂追蹤](../dart_edition/lib/features/revision_tracking/presentation/revision_tracking_panel.dart)、[字數模式](../dart_edition/lib/bin/settings_manager.dart)、[角色類型](../dart_edition/lib/models/character_data.dart) 與[寫作目標](../dart_edition/lib/models/writing_goal_data.dart)。
