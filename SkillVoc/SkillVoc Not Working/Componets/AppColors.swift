import SwiftUI

extension Color {
    static let softGray   = Color(hex: "#F5F0EB")
    static let softGray2  = Color(hex: "#E0DDD8")
    static let softGray3   = Color(hex: "#CCC9C3")
    static let powerCoral = Color(hex: "#E8472A")
    static let powerCoral2 = Color(hex: "#C93B21")  
    static let coralLight  = Color(hex: "#FCEAE6")
    static let darkBase   = Color(hex: "#1C1C1E")
    static let midGray    = Color(hex: "#6C6C70")
    static let okGreen    = Color(hex: "#34C759")
    static let goldXP     = Color(hex: "#F5A623")
    static let warnAmber   = Color(hex: "#FF9500")
    static let dangerRed   = Color(hex: "#FF3B30")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
