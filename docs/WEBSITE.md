# 宣傳網站與 GitHub Pages

網站入口為 `docs/index.html`，採原生 HTML、CSS 與 JavaScript，沒有套件安裝或建置步驟。以繁體中文介紹 Monogatari Assistant，使用 M3 Teal 語意色彩、固定圓角矩形控制項，並提供響應式版面、深淺主題、鍵盤分頁切換、常見問題與圖片預覽。

## 本機預覽

在儲存庫根目錄執行：

```sh
python3 -m http.server 4173 --bind 127.0.0.1 --directory docs
```

瀏覽 `http://127.0.0.1:4173/`。按 Ctrl+C 關閉。也可直接開啟 `docs/index.html`；網站不使用 fetch、模組載入或前端路由。

## 在 GitHub Pages 發佈

1. 將網站檔案提交並推送到儲存庫的 `main` 分支。
2. 開啟儲存庫的 **Settings → Pages**。
3. 在 **Build and deployment → Source** 選擇 **Deploy from a branch**。
4. 分支選擇 **main**，資料夾選擇 **/docs**，按 **Save**。
5. 等待 GitHub Pages 的部署完成，再使用設定頁顯示的網址。

本儲存庫的預期網址為 `https://heyairu.github.io/Monogatari-Assistant-FE/`；此網址須在實際部署成功後才會提供新頁面。詳細設定依 [GitHub 官方發佈指引](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)。

`docs/.nojekyll` 讓 GitHub 直接提供靜態檔案。資源使用相對路徑，適用於專案子路徑及自訂網域。現有 Markdown 說明文件仍留在原路徑；網站連結至 GitHub 上的文件閱讀介面。

## 檔案與維護

| 檔案 | 用途 |
| --- | --- |
| `index.html` | 頁面結構、功能文案、導覽與分享 metadata |
| `assets/site.css` | M3 Teal light／dark tokens、元件、響應式及列印樣式 |
| `assets/site.js` | 主題偏好、手機導覽、可存取的分頁切換與原生 dialog |
| `assets/app-icon.png` | 由專案既有圖示縮小的網站圖示 |
| `assets/screenshots/*.webp` | 從專案實際 Flutter 介面擷取的五張功能畫面 |
| `assets/fonts/*.woff2` | 自架 Noto Sans 與 Noto Sans TC 可變字型，保留 100–900 字重 |
| `assets/fonts/OFL-*.txt` | Noto 官方 SIL Open Font License |
| `assets/social-card.png` | 1200 × 630 分享預覽圖 |
| `tools/build_site_assets.py` | 壓縮展示截圖及依網站文字產生字型子集 |

修改品牌色時，先調整 CSS 的語意 tokens；深色模式同時保留系統偏好規則及明確的 `data-theme="dark"` 覆寫。主題選擇儲存在本機 `localStorage` 的 `monoashi-site-theme`，儲存不可用時仍可切換。全站統一使用 Noto Sans，繁中文字形由 Noto Sans TC 提供。字型隨網站保存及載入，不依賴訪客電腦安裝的字型，也沒有追蹤碼、外部字型請求或 CDN。網頁目前無需額外的等寬字型。

如移轉儲存庫、改用自訂網域或變更預設分支，請同步更新 `index.html` 的 GitHub 文件連結及 `og:image` 絕對網址。可下載版本一律導向 Releases，不預設每個平台都有發佈檔。功能能力與限制以 `GUIDE.md` 及 `API.md` 為準，更新時避免將開發規劃寫成已提供功能。

頁首、功能分頁與畫廊使用實際 Flutter `ContentView`、正文編輯器及各功能模組的介面擷取，展示內容是獨立建立的虛構故事《星海之間》。擷取使用 Flutter 測試渲染器及 `RenderRepaintBoundary.toImage`，不是以 HTML 重畫 App，也不是作業系統視窗截圖；原生外掛與偏好儲存經隔離，不讀取個人稿件。截圖可點擊放大，沒有 JavaScript 時仍可直接開啟圖片。圖片與產品名稱的權利依專案既有商標及授權說明。

## 更新截圖與字型

在 `dart_edition/` 執行：

```sh
flutter test tool/capture_website_screenshots_test.dart --reporter expanded --dart-define=RHODANTHE_MODE=off
```

工具使用專案實際的 Widget、M3 Teal 主題及 Noto Sans 字型，輸出 2400 × 1500 的 PNG 原圖至 `AppPreview/website/`。需要現有 Flutter SDK 與專案相依套件。截圖工具不會控制已開啟的 App 或寫入使用者設定。

再回到儲存庫根目錄執行：

```sh
python3 -m pip install fonttools brotli Pillow
python3 docs/tools/build_site_assets.py
```

這會從原圖輸出網站使用的 WebP，並由專案既有 TTF 建立 WOFF2 子集。更改網頁文案後也應執行一次，確保新增中文字形已包含在字型中。以上都是維護資源時的工具；瀏覽或部署網站仍然不需要建置步驟。

## 設計參考

- [Flutter](https://flutter.dev/)：大標題、留白、產品畫面與清楚的行動入口。
- [Microsoft 365](https://www.microsoft.com/zh-hk/microsoft-365)：分區導覽、互動功能介紹與資源分層。
- [VRoid](https://vroid.com/en)：創作者導向的品牌語氣與世界建構感。
- [Slima](https://slima.ai/zh-TW) 與 [LitMemo](https://litmemo.com/)：用具體故事情境呈現寫作與設定管理。
- [本專案 M3 規範](../MATERIAL_DESIGN_3_GUIDELINES.md)：語意配色、12px 控制項、16px 卡片與克制的互動效果。

參考用於設計方向；頁面未複製第三方文案、圖片、商標或程式碼。
