# `.mnproj` 檔案結構

本文件整理 Monogatari Assistant 專案檔（`.mnproj`）的目前儲存格式，供開發、除錯與資料匯入／匯出時參考。

> 此儲存庫沒有提交實際的 `.mnproj` 範例檔；本文件依目前的讀寫實作整理。現行格式版本為 **1.20**。

## 格式概覽

- 副檔名：`.mnproj`
- 內容：UTF-8 XML
- 根節點：`Project`
- 專案識別：`Project@UUID`，標準 UUID（v4）字串
- 格式版本：`Project > ver`，目前輸出 `1.20`
- 資料單位：每個功能模組以一個 `Type` 節點儲存，並使用其直屬 `Name` 子節點辨識模組。
- 文字欄位會由 XML codec 處理跳脫與換行編碼；請透過程式 codec 修改，不要以字串取代方式直接編輯。

## 頂層樹狀結構

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Project UUID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx">
  <ver>1.20</ver>
  <Type Version="1"> <Name>WritingGoals</Name> … </Type>

  <Type> <Name>BaseInfo</Name> … </Type>
  <Type ChapterTreeVersion="3"> <Name>ChapterSelection</Name> … </Type>
  <Type> <Name>Outline</Name> … </Type>
  <Type> <Name>Timeline</Name> … </Type>
  <Type> <Name>PlanSettings</Name> … </Type>
  <Type> <Name>WorldSettings</Name> … </Type>
  <Type> <Name>Characters</Name> … </Type>
  <Type> <Name>CharacterStates</Name> … </Type>
  <Type> <Name>CharacterStateBaselines</Name> … </Type>
  <Type> <Name>CharacterStateChanges</Name> … </Type>
  <Type> <Name>ItemClasses</Name> … </Type>
  <Type> <Name>ItemInstances</Name> … </Type>
  <Type> <Name>ItemRelations</Name> … </Type>
  <Type> <Name>ItemClassStateChanges</Name> … </Type>
  <Type> <Name>ItemInstanceStateChanges</Name> … </Type>
  <Type> <Name>LocationStateChanges</Name> … </Type>
</Project>
```

除 `Timeline` 外，空資料的模組通常不會寫入。讀取時，缺少的模組會套用程式預設值；同一個可辨識模組出現多次時，只採用第一個有效區塊。

## 模組對照表

| `Type > Name` | 用途 | 主要節點／屬性 |
|---|---|---|
| `WritingGoals` | 檔案專屬字數目標 | 選填 `ChapterWordGoal`、`TotalWordGoal`；`Version=1` |
| `BaseInfo` | 作品基本資料 | `General`、`Tags`、`Stats` |
| `ChapterSelection` | 資料夾、章節與正文 | `Segment`、`Chapter`；`ChapterTreeVersion` |
| `Outline` | 故事線、事件、場景大綱 | `Storyline`、`Event`、`Scene` |
| `Timeline` | 時間軸格線、軌道、配置與章節連結 | `Timeline`、`Grid`、`Track`、`Placement`、`Link` |
| `PlanSettings` | 伏筆與更新計畫 | `ForeshadowList`、`UpdatePlanList` |
| `WorldSettings` | 世界觀／地點階層 | 巢狀 `Location`、`Key` |
| `Characters` | 角色完整檔案 | `Character` 與其分區 |
| `CharacterStates` | 舊式或時間點角色狀態 | `State` |
| `CharacterStateBaselines` | 角色狀態基線 | `Baseline`、`Patch` |
| `CharacterStateChanges` | 場景／時間軸造成的角色狀態異動 | `Change`、`Patch` |
| `ItemClasses` | 物品類別 | `Class`、具型別的 `Field` |
| `ItemInstances` | 物品實例 | `Instance`、具型別的 `Field` |
| `ItemRelations` | 物品與角色、地點、事件或場景的關聯 | `Relation`、具型別的 `Field` |
| `ItemClassStateChanges` | 物品類別快照異動 | `Change`、具型別的 `Field` |
| `ItemInstanceStateChanges` | 物品實例快照異動 | `Change`、具型別的 `Field` |
| `LocationStateChanges` | 地點快照異動 | `Change`、具型別的 `Field` |

## 各模組結構

### WritingGoals（1.20）

```xml
<Type Version="1">
  <Name>WritingGoals</Name>
  <ChapterWordGoal>3000</ChapterWordGoal>
  <TotalWordGoal>120000</TotalWordGoal>
</Type>
```

只保存「僅限本檔案」覆寫，欄位為 1 到 999,999,999 的整數；缺少欄位即動態繼承本機預設，兩者均未覆寫時省略整個 Type。每章目標供本作品所有章節共用。舊檔升級不會把預設值補寫成覆寫。

重複、無效或不支援的區塊會產生 `writing-goals-recovery` 警告，原始 XML 以 `WritingGoalsRecovery` Type 的 Base64 UTF-8 `Data` 保留。使用者修正目標後仍保留復原資料，避免無聲遺失未知欄位。

App 預設目標、每日目標與跨作品每日帳本只存本機，不在專案 XML。局部匯出不夾帶目標，局部匯入保留接收作品覆寫；完整保存、備份及同步會保存覆寫。舊版 App 可能忽略新增 Type 並在重存時遺失覆寫。

### BaseInfo

```xml
<Type>
  <Name>BaseInfo</Name>
  <General>
    <BookName>作品名</BookName>
    <Author>作者</Author>
    <Purpose>創作目的</Purpose>
    <ToRecap>一句話摘要</ToRecap>
    <StoryType>類型</StoryType>
    <Intro>簡介</Intro>
    <LatestSave>2026-09-18T12:34:56.000</LatestSave>
  </General>
  <Tags><Tag>標籤</Tag></Tags>
  <Stats/>
</Type>
```

`LatestSave` 是選填的 ISO 8601 時間。`Stats` 目前會輸出空節點，尚未承載持久化統計值。

### ChapterSelection

```xml
<Type ChapterTreeVersion="3">
  <Name>ChapterSelection</Name>
  <Segment Name="卷一" UUID="segment-uuid">
    <Chapter Name="第一章" UUID="chapter-uuid">
      <Content>章節正文</Content>
    </Chapter>
    <Segment Name="子資料夾" UUID="child-segment-uuid">…</Segment>
  </Segment>
</Type>
```

`Segment` 可遞迴巢狀，並可與 `Chapter` 交錯排列；檔案中的順序即是 UI 的同層排序。`ChapterTreeVersion` 現行為 `3`。

隱藏根 `chapter-tree-root` 不持久化為使用者資料夾；根下儲存 Segment，Segment 下可交錯存放任意層的 Segment 與 Chapter。資料夾／文稿 UUID 在章節樹內唯一，改名、移動與匯出皆保留 UUID。記憶體中的 `childNodeOrder` 僅列直接子項 ID，XML 以實際子元素順序表達相同排序。空資料夾與明確空的 ChapterSelection 亦須保留，不能與缺少該 Type 混為一談。

舊兩層資料直接視為根下資料夾與文稿；v0／v1／v2 沒有混合排序時沿用直接文稿在前、子資料夾在後的順序，v3 以實際元素排列為準。資料模型不設固定業務深度，現行匯出準備有 256 層資源檢查，超出會報錯而非截斷。

細項交換裁切未選兄弟並保留必要祖先鏈與原 ID；根層可附以下獨立 scope，不能以 ChapterTreeVersion 代替其版本：

```xml
<SelectiveExport><Module>Chapters</Module></SelectiveExport>
<ExportScope Version="1">
  <Module Id="Chapters" Mode="partial">
    <Selected Key="chapter:chapter-uuid"/>
    <Structural Key="folder:segment-uuid"/>
  </Module>
</ExportScope>
```

`Selected` 是型別化來源 key，`Structural` 是只附結構的祖先，`Dependency` 是必要實體定義（例如物品實例的 class）。整模組輸出可省略 ExportScope。未知 scope 版本必須拒絕匯入；細項匯入仍為模組替換，需明確確認，含祖先或依賴時禁止替換已有內容的模組。舊版 App 可能忽略 scope，不能宣稱能逐項安全合併。

分檔 ZIP 不改專案 XML 結構。正文一篇文稿一檔，目錄對應原資料夾階層，同層混合順序共同編號；深層／過長路徑改用 `documents/` 短路徑，封裝層 `export-manifest.json`（schemaVersion 1）記錄相對 entry、順序、完整名稱鏈與 pathMode。閱讀封裝不含內部 UUID；交換封裝可含細項 scope。ZIP 整包匯入尚未提供。

### Outline

```xml
<Type>
  <Name>Outline</Name>
  <Storyline Name="主線" Type="主線" UUID="storyline-uuid">
    <Memo>備註</Memo>
    <ConflictPoint>衝突</ConflictPoint>
    <People><Person>character-id</Person></People>
    <Items><Item>物品參照</Item></Items>
    <Event Name="事件" UUID="event-uuid">
      <Scene Name="場景" UUID="scene-uuid">
        <Time>時間文字</Time>
        <TimePoint>ISO 8601 時間點</TimePoint>
        <Location>地點</Location>
        <FocusPoint>焦點</FocusPoint>
        <ConflictPoint>衝突</ConflictPoint>
        <People><Person>character-id</Person></People>
        <Items><Item>物品參照</Item></Items>
        <Doings><Doing>行動</Doing></Doings>
        <Memo>備註</Memo>
      </Scene>
    </Event>
  </Storyline>
</Type>
```

`Memo`、`ConflictPoint`、人物、物品及場景的大部分描述欄位均為選填。`UUID` 用於與時間軸、章節及狀態異動建立參照。

### Timeline

```xml
<Type>
  <Name>Timeline</Name>
  <Timeline SchemaVersion="1">
    <Grid TickValue="1" TickUnit="day" CustomLabel=""
          TicksPerSmallBox="7" TicksPerMiddleBox="4"
          MiddleBoxesPerLargeBox="3" AutoSortOutline="false"
          OriginLabel="" OriginIso8601="…" />
    <Tracks>
      <Track UUID="track-uuid" Name="主時間線" Order="0"
             Collapsed="false" ColorToken="blue" />
    </Tracks>
    <Placements>
      <Placement UUID="placement-uuid" StorylineUUID="…" EventUUID="…"
                 SceneUUID="…" ParentUUID="…" Level="small"
                 TrackUUID="track-uuid" StartTick="0" DurationTicks="1"
                 Order="0" Label="" />
    </Placements>
    <ChapterLinks>
      <Link UUID="link-uuid" SceneUUID="scene-uuid" ChapterUUID="chapter-uuid"
            Sequence="0" Coverage="full" Note="說明" />
    </ChapterLinks>
  </Timeline>
</Type>
```

`OriginIso8601`、`ColorToken`、`StorylineUUID`、`EventUUID`、`SceneUUID`、`ParentUUID` 與 `Note` 是選填屬性。讀取時，沒有有效 `UUID` 或必要參照的軌道、配置或連結會被略過；重複的場景—章節連結只保留第一筆。

### PlanSettings

```xml
<Type>
  <Name>PlanSettings</Name>
  <ForeshadowList>
    <Foreshadow ID="uuid" Revealed="false">
      <Title>伏筆標題</Title><Note>備註</Note>
    </Foreshadow>
  </ForeshadowList>
  <UpdatePlanList>
    <UpdatePlan ID="uuid" Done="false">
      <Title>待辦標題</Title><Note>備註</Note>
    </UpdatePlan>
  </UpdatePlanList>
</Type>
```

`Note` 為選填；若 `ID` 缺失，載入模型會建立新的識別碼。

### WorldSettings

```xml
<Type>
  <Name>WorldSettings</Name>
  <Location>
    <LocalName>王都</LocalName>
    <NodeType>location</NodeType>
    <LocalType>城市</LocalType>
    <Key Name="人口">100000</Key>
    <Memo>備註</Memo>
    <Location>…子地點…</Location>
  </Location>
</Type>
```

`Location` 可遞迴巢狀；`LocalType`、`Key` 和 `Memo` 是選填。節點型態值由 `NodeType` 儲存。

### Characters 與角色狀態

`Characters` 是完整角色檔，角色節點使用 `Id`、`Name` 和 `NanoID` 屬性，並依 UI 分區儲存：`Profile`、`BasicInfo`、`Appearance`、`Personality`、`Ability`、`Social`、`Other`。其中包含文字欄位、列表、核取方塊、滑桿與自訂欄位；應由 `CharacterCodec` 讀寫，避免手動依賴每一個 UI 欄位名稱。

```xml
<Type>
  <Name>CharacterStates</Name>
  <State CharacterId="character-id" StoryTimePointId="optional-id">
    <Location>所在地</Location>
    <HealthStatus>健康</HealthStatus>
    <Emotion>情緒</Emotion>
    <Alignment>陣營</Alignment>
    <Possessions><Item>物品</Item></Possessions>
  </State>
</Type>

<Type>
  <Name>CharacterStateBaselines</Name>
  <Baseline CharacterId="character-id"><Patch>…</Patch><Note>備註</Note></Baseline>
</Type>

<Type>
  <Name>CharacterStateChanges</Name>
  <Change Id="change-id" CharacterId="character-id" SceneId="scene-uuid"
          SourcePlacementId="optional-placement-id" FallbackTick="0" Sequence="0">
    <Patch>…</Patch><Note>備註</Note>
  </Change>
</Type>
```

`Patch` 可選擇性包含 `Conflicts`、`Relationships`、`Organizations`、`StatusEntries`、`Possessions`、`CustomFields`。不存在的 patch 子節點代表「不改變該欄位」，不是清空資料。

### Items 與快照

物品及地點快照的資料採通用「具型別欄位」格式：

```xml
<Type>
  <Name>ItemClasses</Name>
  <Class>
    <Field Name="classId" Type="string">class-id</Field>
    <Field Name="archived" Type="bool">false</Field>
    <Field Name="defaultState" Type="map">
      <Field Name="quantity" Type="int">1</Field>
    </Field>
  </Class>
</Type>
```

| `Type > Name` | 記錄節點 | 說明 |
|---|---|---|
| `ItemClasses` | `Class` | `classId` 必須與模型 map key 一致 |
| `ItemInstances` | `Instance` | `instanceId` 必須與模型 map key 一致 |
| `ItemRelations` | `Relation` | 物品至角色、地點、事件或場景的關聯 |
| `ItemClassStateChanges` | `Change` | 類別層級快照異動 |
| `ItemInstanceStateChanges` | `Change` | 實例層級快照異動 |
| `LocationStateChanges` | `Change` | 地點快照異動 |

`Field@Type` 支援 `null`、`bool`、`int`、`string`、`map`、`list`。`map` 內含巢狀 `Field`，`list` 內含 `Value`。這些模組若解碼失敗，會中止載入，避免下一次儲存時將無法識別的新資料覆寫為空集合。

## 載入、相容性與安全注意事項

- 根節點 `UUID` 缺失或無效時，程式會建立新 UUID，並將專案視為已遷移。
- 讀取到高於支援版本的檔案時，UI 會顯示相容性警告；目前版本為 `1.20`。
- 舊檔會經 `ProjectMigrator` 升級。重要切點包括：章節樹結構、時間軸投影、角色快照與專案 UUID。
- 完全無法解析的 XML 會回退為預設空專案；但物品／地點快照區塊解析失敗會明確報錯，不會靜默遺失資料。
- 選擇性 XML 匯出會額外寫入 `SelectiveExport > Module` 宣告；它是匯出描述，不是一般 `.mnproj` 必要結構。

## 實作來源

| 責任 | 檔案 |
|---|---|
| 專案根結構、序列化與解析 | `lib/bin/file.dart` |
| 專案資料模型與 UUID | `lib/models/project_data.dart` |
| 格式版本與升級邏輯 | `lib/models/project_migrator.dart` |
| 時間軸 XML | `lib/models/codecs/timeline_codec.dart` |
| 物品／快照 XML | `lib/models/codecs/item_codec.dart`、`item_snapshot_codec.dart`、`location_snapshot_codec.dart` |
| 基本資料、章節、大綱、計畫、世界觀、角色 XML | `lib/modules/*view.dart` |
