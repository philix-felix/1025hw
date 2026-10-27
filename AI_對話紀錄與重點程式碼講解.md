# 🤖 AI 協作對話紀錄與重點程式碼講解

本文件整理了開發「**書中自有 XX 屋**」SwiftUI App 過程中與 AI 助手（Antigravity）的完整對話歷程，以及專案的核心程式碼設計講解。

---

## 💬 第一部分：與 AI 的對話歷程整理

### 第 1 階段：製作前 6 座屋子圖片與底下朝上發光的打開書本
- **使用者指令**：
  > 1. 幫我製作房子以搭配書中自有XX屋，除了金珍妮屋之外共五個，金珍妮屋請直接下載blackpink成員jennie的圖片即可  
  > 2. 完工之後，請在各個屋底下加一個打開的書，書頁朝上並發光，光芒依屋子本身而改變
- **AI 提問確認**：
  - 確認五棟房子（黃金、黃鐵礦、白金、白銀、鑽石）採用產生圖片放入 `Assets.xcassets` 的方式，以配合現有的 `Image(maisons[selecteMaisonIndex].image)` 架構。
  - 確認底下的「打開並朝上發光的書」以 SwiftUI 自訂 `Shape` 與漸層視圖在房子下方動態繪製，並隨選中的屋子即時切換光芒顏色與粒子特效。
- **AI 實作成果**：
  - 依據每座屋子的描述（「金玉其內，敗絮其外」、「如假包換，瞞天過海」等）生成 5 張奇幻繪本風建築插畫，並從 Wikimedia Commons 下載 BLACKPINK 成員 Jennie 的照片，建立 6 組 `.imageset`。
  - 在 `maison.swift` 中擴充 `primaryGlowColor`、`glowColors` 與 `sparkleSymbol` 計算屬性。
  - 在 `ContentView.swift` 實作 `GlowingOpenBookView`，包含朝上展開的書頁、射向屋底的光束錐、放射狀光束條、核心光暈與漂浮主題粒子。

---

### 第 2 階段：擴充「大維屋（屋大維）」與「米奇妙妙屋」
- **使用者指令**：
  > 仿造金珍妮，製作屋大維跟米奇妙妙屋的介面，基本程式碼已經打好了，你可以以其爲參考搜尋圖片與擴寫程式碼
- **AI 實作成果**：
  - 讀取使用者在 `ContentView.swift` 新增的兩筆資料：`maison(image: "大維", nom: "大維", description: "八月的羅馬應該一直下雨吧", popularite: 8000)` 與 `maison(image: "米奇妙妙", nom: "米奇妙妙", description: "好帥好帥今天的精彩", popularite: 100)`。
  - 下載羅馬皇帝奧古斯都（屋大維）雕像與《米奇妙妙屋》海報圖片，放入 `Assets.xcassets/大維.imageset` 與 `Assets.xcassets/米奇妙妙.imageset`。
  - 在 `maison.swift` 為「大維」設計羅馬帝國紫紅＋雷雨金藍光芒與月桂冠粒子（`laurel.leading`）；為「米奇妙妙」設計紅黃藍綠歡樂光芒與星星粒子（`star.fill`）。

---

### 第 3 階段：調整標題文字格式
- **使用者指令**：
  > 改回大維屋，不要屋大維！！！
- **AI 實作成果**：
  - 移除特殊標題雙關覆寫，統一使用 `Text("書中自有\(currentMaison.nom)屋")`，讓畫面維持一致的「**書中自有大維屋**」格式。

---

### 第 4 階段：上傳 GitHub 公開儲存庫與撰寫文件
- **使用者指令**：
  > 將 App 上傳到 GitHub，建立 public repository  
  > 幫我撰寫一個詳細的readme並上傳github  
  > 1. 整理與AI的對話並上傳github  
  > 2. 寫給我一個重點程式碼講解
- **AI 實作成果**：
  - 建立公開儲存庫 `https://github.com/philix-felix/1025hw` 並推送完整專案與預覽截圖。
  - 撰寫圖文並茂的 `README.md` 與本篇 `AI_對話紀錄與重點程式碼講解.md` 並同步推送至 GitHub。

---

## 🧠 第二部分：重點程式碼講解

### 1. 資料模型與動態主題計算屬性（`maison.swift`）
在 `maison` 結構中，除了儲存基本屬性（`image`、`nom`、`description`、`popularite`）之外，還運用了 Swift 的**計算屬性（Computed Properties）**，讓「資料本身決定視覺主題」：

```swift
struct maison {
    let image: String
    let nom: String
    let description: String
    let popularite: Int

    /// 主光芒顏色（依屋子本身而改變）
    var primaryGlowColor: Color {
        switch nom {
        case "黃金":
            return Color(red: 1.0, green: 0.84, blue: 0.15)
        case "黃鐵礦":
            return Color(red: 0.76, green: 0.68, blue: 0.22)
        // ... 依不同屋子回傳專屬代表色
        }
    }
}
```
- **為什麼這樣設計？**  
  使用 `switch nom` 計算出 `primaryGlowColor`（主光色）、`glowColors`（多層次漸層色陣列）與 `sparkleSymbol`（SF Symbols 圖示名稱），可以讓 `ContentView` 保持乾淨，不需在畫面程式碼裡寫一堆 `if-else` 判斷顏色。

---

### 2. 狀態管理與隨機抽屋動畫（`ContentView.swift`）
在 `ContentView` 中使用了兩個 `@State` 屬性來驅動畫面更新與動畫：

```swift
@State private var selecteMaisonIndex = 0
@State private var isGlowing = false

private var currentMaison: maison {
    maisons[selecteMaisonIndex]
}
```
- **`selecteMaisonIndex`**：紀錄目前選中的屋子索引。點擊「心想事成」按鈕時：
  ```swift
  Button("心想事成") {
      withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
          selecteMaisonIndex = .random(in: maisons.indices)
      }
  }
  .buttonStyle(.glass)
  .tint(currentMaison.primaryGlowColor)
  ```
  透過 `.random(in: maisons.indices)` 隨機抽取索引，並包在 `withAnimation(.spring(...))` 中，使圖片、背景漸層、書本光芒與按鈕色調平滑過渡。
- **`isGlowing`**：在畫面出現時（`.onAppear`）啟動無限循環的呼吸燈動畫：
  ```swift
  .onAppear {
      withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
          isGlowing = true
      }
  }
  ```
  讓書頁射出的光束錐大小、光束透明度與漂浮粒子位置產生上下浮動的魔法呼吸感。

---

### 3. 屋子與發光書本的疊加排版（`VStack(spacing: -28)` + `zIndex`）
為了讓房子看起來像是「從打開的書頁光芒中浮現」，使用了**負間距 `VStack`** 與 **`zIndex`** 控制前後層次：

```swift
VStack(spacing: -28) {
    Image(currentMaison.image)
        // ... 圖片圓角、發光外框與陰影
        .zIndex(1)
    
    GlowingOpenBookView(maison: currentMaison, isGlowing: isGlowing)
        .frame(height: 155)
        .zIndex(2)
}
```
- `spacing: -28` 讓書本上方的光束與房子底部自然重疊融合，不會有斷裂感。
- `.shadow(color: currentMaison.primaryGlowColor.opacity(0.75), radius: 22, x: 0, y: 12)` 讓屋子底部散發出與書頁相同色系的環境光。

---

### 4. 用 SwiftUI `Shape` 繪製「打開且書頁朝上發光」的書（`GlowingOpenBookView`）
`GlowingOpenBookView` 透過 `ZStack(alignment: .bottom)` 由後往前疊加了 5 個視覺層次：

1. **大範圍朝上光束錐（`UpwardLightConeShape`）**：下窄上寬的梯形路徑，填入由下往上淡出的 `LinearGradient` 並加上 `.blur(radius: 14)` 製造柔和光霧。
2. **放射狀光束條（`ForEach(0..<7)` + `Capsule`）**：以 `.rotationEffect(.degrees(angle), anchor: .bottom)` 從書脊中心向左右扇形展開 7 道光束，並依序套用 `maison.glowColors` 的顏色（例如鑽石屋會呈現七彩稜鏡光束）。
3. **書頁核心光暈（`Ellipse` + `RadialGradient`）**：在書頁正上方放置白色至主光色的放射漸層橢圓，模擬書頁表面強烈發光。
4. **主題微光粒子（`HStack` + `Image(systemName:)`）**：根據 `maison.sparkleSymbol` 顯示對應符號（如黃金屋顯示星芒、白金屋顯示皇冠、金珍妮屋顯示愛心、大維屋顯示桂冠、米奇妙妙屋顯示星星）。
5. **立體打開書本（`OpenBookCoverShape` & `OpenBookPagesShape`）**：
   - 使用二次貝茲曲線 `path.addQuadCurve(to:control:)` 繪製左右兩頁向上拱起的弧度：
   ```swift
   // 左頁上表面弧線（朝上拱起）
   path.move(to: CGPoint(x: w * 0.05, y: h * 0.30))
   path.addQuadCurve(
       to: CGPoint(x: midX, y: h * 0.68),
       control: CGPoint(x: w * 0.28, y: topY)
   )
   // 右頁上表面弧線（朝上拱起）
   path.addQuadCurve(
       to: CGPoint(x: w * 0.95, y: h * 0.30),
       control: CGPoint(x: w * 0.72, y: topY)
   )
   ```
   - 透過控制點 `topY = h * (0.18 - archLift)` 向上拉高，表現出書頁翻開朝上受光並向外散發魔力的立體感。
