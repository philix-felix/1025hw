//
//  maison.swift
//  10.25 作業
//
//  Created by 115-1Student15 on 2026/10/20.
//

import SwiftUI

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
        case "白金":
            return Color(red: 0.78, green: 0.90, blue: 1.0)
        case "白銀":
            return Color(red: 0.72, green: 0.88, blue: 0.84)
        case "鑽石":
            return Color(red: 0.45, green: 0.92, blue: 1.0)
        case "金珍妮":
            return Color(red: 1.0, green: 0.22, blue: 0.62)
        case "大維":
            // 羅馬帝國紫紅與雷雨金輝（呼應「八月的羅馬應該一直下雨吧」）
            return Color(red: 0.85, green: 0.22, blue: 0.28)
        case "米奇妙妙":
            // 米奇妙妙屋經典歡樂亮紅與金黃配色
            return Color(red: 1.0, green: 0.26, blue: 0.18)
        default:
            return .yellow
        }
    }

    /// 次要漸層光芒顏色陣列（用於書頁朝上發出的多層次光束與光暈）
    var glowColors: [Color] {
        switch nom {
        case "黃金":
            return [
                Color(red: 1.0, green: 0.95, blue: 0.60),
                Color(red: 1.0, green: 0.80, blue: 0.10),
                Color.orange
            ]
        case "黃鐵礦":
            return [
                Color(red: 0.85, green: 0.78, blue: 0.35),
                Color(red: 0.42, green: 0.58, blue: 0.32),
                Color(red: 0.55, green: 0.46, blue: 0.16)
            ]
        case "白金":
            return [
                Color.white,
                Color(red: 0.75, green: 0.88, blue: 1.0),
                Color(red: 0.45, green: 0.68, blue: 0.95)
            ]
        case "白銀":
            return [
                Color.white,
                Color(red: 0.78, green: 0.85, blue: 0.88),
                Color(red: 0.52, green: 0.76, blue: 0.70)
            ]
        case "鑽石":
            return [
                Color.white,
                Color.cyan,
                Color(red: 0.78, green: 0.52, blue: 1.0),
                Color.pink,
                Color.yellow
            ]
        case "金珍妮":
            return [
                Color(red: 1.0, green: 0.75, blue: 0.90),
                Color(red: 1.0, green: 0.18, blue: 0.58),
                Color(red: 0.65, green: 0.10, blue: 0.55)
            ]
        case "大維":
            return [
                Color(red: 1.0, green: 0.86, blue: 0.42),
                Color(red: 0.85, green: 0.18, blue: 0.25),
                Color(red: 0.45, green: 0.62, blue: 0.88)
            ]
        case "米奇妙妙":
            return [
                Color(red: 1.0, green: 0.90, blue: 0.15),
                Color(red: 1.0, green: 0.20, blue: 0.18),
                Color(red: 0.20, green: 0.75, blue: 1.0),
                Color(red: 0.30, green: 0.88, blue: 0.38)
            ]
        default:
            return [.white, .yellow, .orange]
        }
    }

    /// 光芒粒子符號
    var sparkleSymbol: String {
        switch nom {
        case "黃金":
            return "sparkles"
        case "黃鐵礦":
            return "cube.fill"
        case "白金":
            return "crown.fill"
        case "白銀":
            return "leaf.fill"
        case "鑽石":
            return "diamond.fill"
        case "金珍妮":
            return "heart.fill"
        case "大維":
            return "laurel.leading"
        case "米奇妙妙":
            return "star.fill"
        default:
            return "sparkles"
        }
    }
}
