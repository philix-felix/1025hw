import SwiftUI
import Playgrounds

struct ContentView: View {
    
    let maisons = [
        maison(image: "黃金", nom: "黃金", description: "其實金玉其內，敗絮其外。", popularite: 10000),
        maison(image: "黃鐵礦", nom: "黃鐵礦", description: "如假包換，瞞天過海", popularite: -10000),
        maison(image: "白金", nom: "白金", description: "怨嗟無一世英主我顧啊", popularite: 800),
        maison(image: "白銀", nom: "白銀", description: "淡泊如淵明，協臥五柳樹下", popularite: 1500),
        maison(image: "鑽石", nom: "鑽石", description: "鋒芒畢露，耀眼奪目", popularite: 1000000),
        maison(image: "金珍妮", nom: "金珍妮", description: "Hit you with that Dhu-dhu-du", popularite: 99999),
        maison(image: "大維", nom: "大維", description: "八月的羅馬應該一直下雨吧", popularite: 8000),
        maison(image: "米奇妙妙", nom: "米奇妙妙", description: "好帥好帥今天的精彩", popularite: 100)
    ]
    
    @State private var selecteMaisonIndex = 0
    @State private var isGlowing = false
    
    private var currentMaison: maison {
        maisons[selecteMaisonIndex]
    }
    
    var body: some View {
        ZStack {
            // 背景隨屋子光芒呈現深邃氛圍漸層
            RadialGradient(
                colors: [
                    currentMaison.primaryGlowColor.opacity(0.28),
                    Color(red: 0.05, green: 0.06, blue: 0.12),
                    Color.black
                ],
                center: .center,
                startRadius: 30,
                endRadius: 480
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: selecteMaisonIndex)
            
            VStack(spacing: 16) {
                Spacer(minLength: 8)
                
                // 屋子與底下朝上發光的打開書本
                VStack(spacing: -28) {
                    // 屋子圖片（受底下書頁光芒照亮）
                    Image(currentMaison.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            currentMaison.primaryGlowColor.opacity(0.45),
                                            currentMaison.primaryGlowColor,
                                            .white.opacity(0.85)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: currentMaison.primaryGlowColor.opacity(0.75), radius: 22, x: 0, y: 12)
                        .padding(.horizontal, 28)
                        .zIndex(1)
                    
                    // 屋子底下：打開的書，書頁朝上並依屋子本身改變光芒
                    GlowingOpenBookView(maison: currentMaison, isGlowing: isGlowing)
                        .frame(height: 155)
                        .padding(.horizontal, 16)
                        .zIndex(2)
                }
                .animation(.easeInOut(duration: 0.5), value: selecteMaisonIndex)
                
                // 標題與描述文字
                VStack(spacing: 8) {
                    Text("書中自有\(currentMaison.nom)屋")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, currentMaison.primaryGlowColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: currentMaison.primaryGlowColor.opacity(0.7), radius: 8)
                    
                    Text(currentMaison.description)
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.88))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text("熱門度：\(currentMaison.popularite)")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.88))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 4)
                
                Button("心想事成") {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                        selecteMaisonIndex = .random(in: maisons.indices)
                    }
                }
                .buttonStyle(.glass)
                .tint(currentMaison.primaryGlowColor)
                .controlSize(.large)
                .padding(.top, 6)
                
                Spacer(minLength: 12)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}

// MARK: - 打開並朝上發光的書本視圖
struct GlowingOpenBookView: View {
    let maison: maison
    let isGlowing: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. 從朝上的書頁往屋子底部射出的大範圍光束錐
            UpwardLightConeShape()
                .fill(
                    LinearGradient(
                        colors: [
                            maison.primaryGlowColor.opacity(0.85),
                            (maison.glowColors.dropFirst().first ?? maison.primaryGlowColor).opacity(0.42),
                            .clear
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(height: 165)
                .blur(radius: 14)
                .scaleEffect(x: isGlowing ? 1.05 : 0.96, y: isGlowing ? 1.06 : 0.94, anchor: .bottom)
                .offset(y: -22)
            
            // 2. 放射狀朝上光束條（鑽石屋與黃金屋等呈現不同色澤光束）
            ZStack {
                ForEach(0..<7, id: \.self) { index in
                    let angle = Double(index - 3) * 11.5
                    let beamColor = maison.glowColors[index % maison.glowColors.count]
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.9),
                                    beamColor.opacity(0.75),
                                    .clear
                                ],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: index == 3 ? 18 : 10, height: index % 2 == 0 ? 135 : 115)
                        .blur(radius: 4)
                        .rotationEffect(.degrees(angle), anchor: .bottom)
                }
            }
            .offset(y: -26)
            .opacity(isGlowing ? 0.95 : 0.65)
            
            // 3. 書頁上方的核心強烈光暈（照亮書頁與屋底）
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            .white,
                            maison.primaryGlowColor,
                            maison.primaryGlowColor.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: 4,
                        endRadius: 120
                    )
                )
                .frame(width: 260, height: 64)
                .blur(radius: 8)
                .offset(y: -24)
            
            // 4. 隨屋子主題浮現的微光粒子
            HStack(spacing: 34) {
                ForEach(0..<5, id: \.self) { idx in
                    Image(systemName: idx % 2 == 0 ? maison.sparkleSymbol : "sparkle")
                        .font(.system(size: idx == 2 ? 16 : 12, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: maison.primaryGlowColor, radius: 6)
                        .offset(
                            y: CGFloat(idx % 2 == 0 ? -52 : -36) + (isGlowing ? -8 : 6)
                        )
                }
            }
            .offset(y: -18)
            
            // 5. 打開的書本本體（書封、厚書頁層、朝上翻開並發光的書頁）
            ZStack {
                // 精裝書封底座
                OpenBookCoverShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.28, green: 0.16, blue: 0.10),
                                Color(red: 0.16, green: 0.09, blue: 0.06)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        OpenBookCoverShape()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        maison.primaryGlowColor.opacity(0.9),
                                        Color(red: 0.75, green: 0.58, blue: 0.28)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: maison.primaryGlowColor.opacity(0.55), radius: 14, x: 0, y: 4)
                
                // 書頁厚度層（外層書頁）
                OpenBookPagesShape(archLift: 0.0)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.94, green: 0.90, blue: 0.82),
                                maison.primaryGlowColor.opacity(0.45),
                                Color(red: 0.78, green: 0.72, blue: 0.62)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .padding(.horizontal, 8)
                    .padding(.bottom, 5)
                
                // 朝上翻開並發光的主書頁（書頁朝上受光）
                OpenBookPagesShape(archLift: 0.14)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white,
                                maison.primaryGlowColor.opacity(0.55),
                                Color(red: 0.98, green: 0.95, blue: 0.88)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        OpenBookPagesShape(archLift: 0.14)
                            .stroke(.white.opacity(0.95), lineWidth: 1.8)
                    )
                    .shadow(color: maison.primaryGlowColor, radius: 12, x: 0, y: -4)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 9)
                
                // 微微向上翻起的內頁（強化「書頁朝上並發光」的立體層次）
                OpenBookInnerLeafShape()
                    .stroke(
                        LinearGradient(
                            colors: [.white, maison.primaryGlowColor, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2.2
                    )
                    .shadow(color: maison.primaryGlowColor, radius: 8)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 14)
                
                // 書頁上的發光符文線條
                BookGlowingTextLines(color: maison.primaryGlowColor)
                    .padding(.horizontal, 42)
                    .padding(.bottom, 16)
            }
            .frame(height: 68)
        }
    }
}

// MARK: - 朝上發光的光束錐形狀
struct UpwardLightConeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topInset: CGFloat = rect.width * 0.04
        let bottomInset: CGFloat = rect.width * 0.18
        
        path.move(to: CGPoint(x: bottomInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: topInset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width - topInset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width - bottomInset, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - 打開的精裝書封底座
struct OpenBookCoverShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let midX = w * 0.5
        
        // 左側書封上緣至書脊中央
        path.move(to: CGPoint(x: w * 0.06, y: h * 0.36))
        path.addQuadCurve(
            to: CGPoint(x: midX, y: h * 0.72),
            control: CGPoint(x: w * 0.28, y: h * 0.26)
        )
        // 右側書封上緣
        path.addQuadCurve(
            to: CGPoint(x: w * 0.94, y: h * 0.36),
            control: CGPoint(x: w * 0.72, y: h * 0.26)
        )
        // 右側書封外斜邊（透視感）
        path.addLine(to: CGPoint(x: w, y: h * 0.80))
        // 右側書封底緣至書脊凹槽
        path.addQuadCurve(
            to: CGPoint(x: midX - w * 0.03, y: h * 0.94),
            control: CGPoint(x: w * 0.74, y: h * 0.76)
        )
        // 中央書脊圓弧
        path.addQuadCurve(
            to: CGPoint(x: midX + w * 0.03, y: h * 0.94),
            control: CGPoint(x: midX, y: h * 1.04)
        )
        // 左側書封底緣
        path.move(to: CGPoint(x: w * 0.06, y: h * 0.36))
        path.addLine(to: CGPoint(x: 0, y: h * 0.80))
        path.addQuadCurve(
            to: CGPoint(x: midX, y: h * 0.98),
            control: CGPoint(x: w * 0.26, y: h * 0.76)
        )
        path.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.80),
            control: CGPoint(x: w * 0.74, y: h * 0.76)
        )
        path.addLine(to: CGPoint(x: w * 0.94, y: h * 0.36))
        path.closeSubpath()
        return path
    }
}

// MARK: - 朝上翻開的書頁形狀
struct OpenBookPagesShape: Shape {
    var archLift: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let midX = w * 0.5
        let topY = h * (0.18 - archLift)
        
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
        // 右側書頁側邊厚度
        path.addLine(to: CGPoint(x: w * 0.98, y: h * 0.68))
        // 右頁下緣弧線回書脊
        path.addQuadCurve(
            to: CGPoint(x: midX, y: h * 0.90),
            control: CGPoint(x: w * 0.74, y: h * 0.64)
        )
        // 左頁下緣弧線至左側
        path.addQuadCurve(
            to: CGPoint(x: w * 0.02, y: h * 0.68),
            control: CGPoint(x: w * 0.26, y: h * 0.64)
        )
        path.closeSubpath()
        return path
    }
}

// MARK: - 向上微微掀起的發光內頁弧線
struct OpenBookInnerLeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let midX = w * 0.5
        
        path.move(to: CGPoint(x: w * 0.04, y: h * 0.16))
        path.addQuadCurve(
            to: CGPoint(x: midX, y: h * 0.66),
            control: CGPoint(x: w * 0.30, y: -h * 0.12)
        )
        path.addQuadCurve(
            to: CGPoint(x: w * 0.96, y: h * 0.16),
            control: CGPoint(x: w * 0.70, y: -h * 0.12)
        )
        return path
    }
}

// MARK: - 書頁朝上表面的發光文字線條
struct BookGlowingTextLines: View {
    let color: Color
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            Path { path in
                for row in 0..<3 {
                    let yOffset = CGFloat(row) * 7.0
                    // 左頁文字弧線
                    path.move(to: CGPoint(x: w * 0.08, y: h * 0.38 + yOffset))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.44, y: h * 0.58 + yOffset),
                        control: CGPoint(x: w * 0.26, y: h * 0.26 + yOffset)
                    )
                    // 右頁文字弧線
                    path.move(to: CGPoint(x: w * 0.56, y: h * 0.58 + yOffset))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.92, y: h * 0.38 + yOffset),
                        control: CGPoint(x: w * 0.74, y: h * 0.26 + yOffset)
                    )
                }
            }
            .stroke(color.opacity(0.65), style: StrokeStyle(lineWidth: 1.4, lineCap: .round, dash: [6, 4]))
        }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
