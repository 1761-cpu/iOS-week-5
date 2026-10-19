import SwiftUI

// MARK: - TITLE BADGE
struct TitleBadge: View {
    let text: String
    let color: Color
    let glassTint: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold, design: .monospaced))
            .foregroundColor(color)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            // Dùng Material làm hiệu ứng kính mờ thay cho glassEffect (tương thích iOS 17)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// MARK: - TOP BAR
struct TopBar: View {
    let title: String
    var color: Color = .black
    var glassTint: Color = .blue.opacity(0.9)
    
    var body: some View {
        HStack {
            Spacer()
            TitleBadge(text: title, color: color, glassTint: glassTint)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .background(
            // Nền gradient mờ để header nổi bật hơn
            LinearGradient(
                colors: [Color(hex: "#F2F2F7").opacity(0.95), Color(hex: "#F2F2F7").opacity(0.0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
        )
    }
}

// MARK: - SECTION TAG
struct SectionTag: View {
    let text: String
    var systemImage: String? = nil
    let color: Color
    
    init(_ text: String, systemImage: String? = nil, color: Color) {
        self.text = text
        self.systemImage = systemImage
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(text)
        }
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color, in: RoundedRectangle(cornerRadius: 10))
        .textCase(nil)
        .padding(.vertical, 4)
    }
}
